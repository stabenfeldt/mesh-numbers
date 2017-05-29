# MESH Numbers

## Get rolling with Docker Swarm

Run `setup-swarm.sh` to setup a swarm running locally.

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
docker-compose up
```

Use `docker-compose ps` to check when the service is ready.
And then `open http://$(docker-machine ip swarm-1)`
