# MESH Numbers

## Get rolling with Docker Swarm

Run `setup-swarm.sh` to setup a swarm running locally.

### Deploy the services

eval $(docker-machine env swarm-1)

docker network create --driver overlay proxy
docker stack deploy -c docker-compose-swarm.yml mesh

docker stack ps mesh

curl -i "http://$(docker-machine ip swarm-1):3000"

### Rebuild images

## The workflow
It's faster to make changes to images when using docker-compose, than when using Docker flow.
When using docker stack you should have verified that the images are working already.
I find the easiest way to do that is using docker-flow.

```bash
eval $(docker-machine env swarm-1)
docker-compose up --build
```

Use `docker-compose ps` to check when the service is ready.
And then `open http://$(docker-machine ip swarm-1)`

When you know the images are beeing properly buildt here, it'd time to test with _docker stack_.

### Docker Stack
If you need to change settings for the postgres container, remember to vipe it's volumne, otherwize the info set in
ENV vars is ignored.
docker volume ls
docker volume rm $ID

E.g running rake db:migrate
First, check which server that is running rails:

```bash
$ docker stack ps mesh

ID            NAME             IMAGE                            NODE     DESIRED STATE  CURRENT STATE           ERROR  PORTS
2ffecz52f0m8  mesh_website.1   stabenfeldt/mesh-numbers:latest  swarm-2  Running        Running 23 minutes ago
ai0zclfg4ts0  mesh_postgres.1  postgres:9.5                     swarm-1  Running        Running 23 minutes ago
```

Set swarm-2 as the target for our docker commands:
`eval $(docker-machine env swarm-2)`

Run the rake command on the docker image running at the machine swarm-2:
```bash
docker exec -it $(docker ps | tail -1 | cut -f1 -d" ") rake db:migrate
```


# Running at Digital Ocean

```bash

docker-machine create --driver digitalocean  --digitalocean-size 1gb  --digitalocean-private-networking  do-swarm-1


# Remember to change 'do-swarm' here if if you have changed it in $SWARM above.

MANAGER_IP=$(curl -X GET \
	-H "Authorization: Bearer $DIGITALOCEAN_ACCESS_TOKEN"  "https://api.digitalocean.com/v2/droplets" \
	| jq -r '.droplets[]
	| select(.name=="do-swarm-1").networks.v4[]
	| select(.type=="private").ip_address')

echo "Manager IP is ${MANAGER_IP}"

eval $(docker-machine env do-swarm-1)
docker swarm init --advertise-addr $MANAGER_IP

# Confirm that the cluster is running
docker node ls

# Now that we initialized the cluster, we can add more nodes. We’ll start by creating two new instances and joining them as managers.

MANAGER_TOKEN=$(docker swarm join-token -q manager)
echo "MANAGER_TOKEN is ${MANAGER_TOKEN}"

for i in 2 3; do docker-machine create \
	--driver digitalocean \
	--digitalocean-size 1gb \
  --digitalocean-private-networking \
  do-swarm-$i

	IP=$(curl -X GET \
		-H "Authorization: Bearer $DIGITALOCEAN_ACCESS_TOKEN"  "https://api.digitalocean.com/v2/droplets" \
		| jq -r ".droplets[]
		| select(.name==\"do-swarm-$i\").networks.v4[]
		| select(.type==\"private\").ip_address")

	eval $(docker-machine env do-swarm-$i)

	docker swarm join  --token $MANAGER_TOKEN  --advertise-addr $IP  $MANAGER_IP:2377

done



```
