

# Docker

+ `docker ps --filter "status=exited"`
+ `docker ps -a`
+ `docker kill <containerId>`
+ `docker rm <containerId>`
+ `docker start <containerId>`
+ `docker exec -it <containerId> /bin/sh`
+ `docker build -t <image> <Dockerfile dir>`
+ `docker run -it -p <inner>:<outer> --rm --name <container> <image>`
+ `docker inspect <containerId>`

## Shared volumes path (& view them on Ubuntu's Nautilus):
+ `docker inspect <containerId> | grep -E -o '"Source": "(.)*"' | sed 's/"//g' | sed "s/Source: //g" | xargs nautilus`




--------------------------

`docker run --name <new container name> -e <ENV Variable> -d mysql:tag`
+ **--name string** | Assign a name to the container
+ **-e | –env | –env-file** | Set environment variables
+ **-d | --detach**  | Run container in background and print container ID


RE: [Docker.com](https://docs.docker.com/engine/reference/commandline/run/)
