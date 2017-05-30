#!/usr/bin/env bash -e

if [[ "$(uname -s )" == "Linux" ]]; then
  export VIRTUALBOX_SHARE_FOLDER="$PWD:$PWD"
fi

echo ========= Creating droplets

for i in 1 2 3; do
    docker-machine create \
      --driver digitalocean \
      --digitalocean-image ubuntu-16-04-x64 \
      --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
      digitalOceanSwarm-$i
done

eval $(docker-machine env digitalOceanSwarm-1)

echo ========= Swarm init
echo ========= Adding 2 and 3 as managers.

docker swarm init \
  --advertise-addr $(docker-machine ip digitalOceanSwarm-1)

TOKEN=$(docker swarm join-token -q manager)

for i in 2 3; do
    eval $(docker-machine env digitalOceanSwarm-$i)

    docker swarm join \
        --token $TOKEN \
        --advertise-addr $(docker-machine ip digitalOceanSwarm-$i) \
        $(docker-machine ip digitalOceanSwarm-1):2377
done

echo ========= Add labels
for i in 1 2 3; do
    eval $(docker-machine env digitalOceanSwarm-$i)

    docker node update \
        --label-add env=prod \
        digitalOceanSwarm-$i
done

echo ">> The swarm cluster is up and running"
