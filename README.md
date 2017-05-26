# MESH Numbers

## Get rolling with Docker Swarm

Run `setup-swarm.sh` to setup a swarm running locally.

eval $(docker-machine env swarm-1)

docker network create --driver overlay proxy
docker stack deploy -c docker-compose-swarm.yml mesh

docker stack ps mesh

curl -i "http://$(docker-machine ip swarm-1):3000"

### Rebuild images
