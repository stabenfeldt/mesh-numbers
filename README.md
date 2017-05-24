# MESH Numbers

## Get rolling with Docker Swarm

docker network create --driver overlay proxy
docker stack deploy -c docker-compose-swarm.yml mesh

docker stack ps mesh

curl -i "http://$(docker-machine ip swarm-1)/demo/hello"
