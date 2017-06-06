#!/bin/bash

if ! [ $MESH_DIGITALOCEAN_ACCESS_TOKEN ]
then
  echo "You must export MESH_DIGITALOCEAN_ACCESS_TOKEN"
  exit 1
fi

if ! [ `which jq` ]
then
  echo "Run brew install jq"
	exit 1
fi


printf "Starting a swarm on Digital Ocean. Hold thight \n"

export DIGITALOCEAN_REGION="ams3"

printf "Creating do-swarm-1, our manager node"
docker-machine create --driver digitalocean  --digitalocean-size 1gb  --digitalocean-private-networking  do-swarm-1

MANAGER_IP=$(curl -X GET \
	-H "Authorization: Bearer $MESH_DIGITALOCEAN_ACCESS_TOKEN"  "https://api.digitalocean.com/v2/droplets" \
	| jq -r '.droplets[]
	| select(.name=="do-swarm-1").networks.v4[]
	| select(.type=="private").ip_address')

printf "Manager IP is ${MANAGER_IP}"

eval $(docker-machine env do-swarm-1)

printf "=============================================== docker swarm init "
docker swarm init --advertise-addr $MANAGER_IP

# Confirm that the cluster is running
printf docker node ls
docker node ls

# Now that we initialized the cluster, we can add more nodes. We’ll start by creating two new instances and joining them as managers.

MANAGER_TOKEN=$(docker swarm join-token -q manager)
printf "MANAGER_TOKEN is ${MANAGER_TOKEN} "

printf "Starting do-swarm-2 and do-swarm-3 "

# TODO Run this in parallell threads.
for i in 2 3; do docker-machine create \
	--driver digitalocean \
	--digitalocean-size 1gb \
  --digitalocean-private-networking \
  do-swarm-$i

	IP=$(curl -X GET \
		-H "Authorization: Bearer $MESH_DIGITALOCEAN_ACCESS_TOKEN"  "https://api.digitalocean.com/v2/droplets" \
		| jq -r ".droplets[]
		| select(.name==\"do-swarm-$i\").networks.v4[]
		| select(.type==\"private\").ip_address")

  printf " Started machine 'do-swarm-$i' with IP $IP "

	eval $(docker-machine env do-swarm-$i)

  printf "Telling it to join our swarm:"

	docker swarm join  --token $MANAGER_TOKEN  --advertise-addr $IP  $MANAGER_IP:2377

done

# Add a few workers

eval $(docker-machine env do-swarm-1)
WORKER_TOKEN=$(docker swarm join-token -q worker)
printf "WORKER_TOKEN: ${WORKER_TOKEN}"

# TODO Run this in parallell threads.

for i in 4 5; do docker-machine create \
	--driver digitalocean --digitalocean-size 1gb  \
  --digitalocean-private-networking \
  do-swarm-$i

	IP=$(curl -X GET \
	-H "Authorization: Bearer $MESH_DIGITALOCEAN_ACCESS_TOKEN"  "https://api.digitalocean.com/v2/droplets" \
	| jq -r ".droplets[]
	| select(.name==\"do-swarm-$i\").networks.v4[]
	| select(.type==\"private\").ip_address")

  printf "IP for new worker is $IP"
	eval $(docker-machine env do-swarm-$i)

	docker swarm join \
  --token $WORKER_TOKEN \
  --advertise-addr $IP \
  $MANAGER_IP:2377

done


printf "Let’s confirm that all five nodes are indeed forming the cluster."

eval $(docker-machine env do-swarm-1)
docker-machine ls
docker node ls

printf "DONE! \n"
