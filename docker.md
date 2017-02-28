

# Docker


### List
+ `docker ps --filter "status=exited"`
+ `docker ps -a`
+ `docker images`
+ `docker inspect <containerId>`
+ `docker inspect <containerId> | grep -E -o '"Source": "(.)*"' | sed 's/"//g' | sed "s/Source: //g" | xargs nautilus`

### Remove
+ `docker kill <containerId>`
+ `docker rm <containerId>`
+ `docker rm $(docker ps -a -q)`
+ `docker rmi <image>`
+ `docker rmi $(docker images -q)`

### Build
+ `docker build -t <image> <Dockerfile dir>`

### Run
+ `docker start <containerId>`
+ `docker exec -it <containerId> /bin/sh`
+ `docker run -it -p <inner>:<outer> --rm --name <container> <image>`
+ [External ENV](https://docs.docker.com/engine/reference/commandline/run/): `docker run --name <container> –env-file <ENV_FILE> <image>`
+ [host network](https://docs.docker.com/engine/reference/run/#network-host): `docker run -it --rm --net="host" --name <container> <image>`
+ [thread run](https://docs.docker.com/engine/reference/commandline/run/): `docker run --name <new container name> -e <ENV Variable> --detach mysql:tag`
