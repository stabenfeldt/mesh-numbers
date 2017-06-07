[![CircleCI](https://circleci.com/gh/stabenfeldt/mesh-numbers.svg?style=svg)](https://circleci.com/gh/stabenfeldt/mesh-numbers)

# MESH Numbers

It's a simple Rails app that feeds json streams that Klipfolio consumes.
It's set up with CD using Circle.ci. Read the [config here](https://github.com/stabenfeldt/mesh-numbers/blob/master/.circleci/config.yml).

## Howto get started

### Locally

Run `setup-swarm.sh` to setup a swarm running locally.

### On Digital Ocean


Run `setup-digital-ocean-droplets.sh` to start enough machines to host our swarm.
When that is done you can deploy our swarm to those machines.


## Deploy

### Locally
```bash
eval $(docker-machine env swarm-1)
docker-compose up 
```

### On Digital Ocean

```bash
eval $(docker-machine env do-swarm-1)

docker network create --driver overlay proxy
docker stack deploy -c docker-compose-swarm.yml mesh

docker stack ps mesh

curl -i "http://$(docker-machine ip do-swarm-1):3000"
```

## Rebuild images

### The workflow
Use docker-compose when you're doing the testing and building cycles of the images.
When using docker stack you should have verified that the images are working already.


```bash

eval $(docker-machine env swarm-1)
docker-compose up --build

```

Use `docker-compose ps` to check when the service is ready.
And then `open http://$(docker-machine ip swarm-1)`

When you know the images are beeing properly buildt here, it'd time to test with _docker stack_.
```bash

# swarm-1 is created by setup-swarm.sh
eval $(docker-machine env swarm-1) 
```
Then run the same steps as described in ['On Digital Ocean'](#on-digital-ocean). Just remember to replace do-swarm with swarm.

### Nice to know
If you need to change settings for the postgres container, remember to vipe it's volumne, otherwise changes made to
ENV vars is ignored.
```bash
docker volume ls
docker volume rm $ID
```


## Running commands within container

### Swarm cluster on DigitalOcean
E.g running rake db:migrate
First, figure out which server the container is running on. Here we're looking for the one hosting the website.

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

### Docker Compose locally
E.g running rake db:migrate or rspec
`docker-compose run website rspec`

