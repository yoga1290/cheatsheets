

# Docker

+ `docker ps --filter "status=exited"`
+ `docker kill <containerId>`
+ `docker rm <containerId>`
+ `docker start <containerId>`
+ `docker exec -it <containerId> /bin/sh`
+ `docker build -t <image> <Dockerfile dir>`
+ `docker run -it -p <inner>:<outer> --rm --name <container> <image>`
