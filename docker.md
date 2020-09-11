# Outline

+ [Docker](#docker)
+ [Docker-Compose](#docker)
    + [Mongo](#mongo)
    + [MySQL](#mysql)
    + [NGINX](#nginx)

--------

# Docker

+ [Minimal JDK](https://developer.atlassian.com/blog/2015/08/minimal-java-docker-containers/)

### List
+ `docker ps --filter "status=exited"`
+ `docker ps -a`
+ `docker images`
+ `docker inspect <containerId>`
+ `docker inspect <containerId> | grep -E -o '"Source": "(.)*"' | sed 's/"//g' | sed "s/Source: //g" | xargs nautilus`
+ `docker top <containerId>`

+ `docker network ls`
+ `docker network create <name>`
+ `docker network inspect <name>`

### Remove
+ `docker kill <containerId>`
+ `docker [container] rm <containerId>`
+ `docker [container] rm $(docker ps -a -q)`
+ `docker rmi <image>`
+ `docker rmi $(docker images -q)`

### Build
+ `docker build -t <image> <Dockerfile dir>`

### Run
+ `docker [container] start <containerId>`
+ `docker [container] stop <containerId>`
+ `docker [container] port <containerId>`
+ `docker exec -it <containerId> /bin/sh`
+ `docker [container] run -it -p <inner>:<outer> --rm --name <container> <image>`
+ [External ENV](https://docs.docker.com/engine/reference/commandline/run/): `docker run --name <container> --env-file <ENV_FILE> <image>`
+ [host network](https://docs.docker.com/engine/reference/run/#network-host): `docker run -it --rm --net="host" --name <container> <image>`
+ [thread run](https://docs.docker.com/engine/reference/commandline/run/): `docker run --name <new container name> -e <ENV Variable> --detach mysql:tag`

### Readings & Issues

+ [Manage docker as a non-root user](https://docs.docker.com/engine/installation/linux/linux-postinstall/#manage-docker-as-a-non-root-user)


# Docker Compose:

## Mongo

```yaml
services:

    database:
      # https://hub.docker.com/_/mongo
      image: mongo:4.0
      volumes:
        - dbdata:/data/db

        - ./docker-database-mongod.conf:/etc/mongod.conf.orig
        # to enable auth, add the following to mongod.conf.orig:
        ############################
        # security:
        #   authorization: enabled
        ###########################
        # see https://docs.mongodb.com/manual/tutorial/enable-authentication/#re-start-the-mongodb-instance-with-access-control

        - ./docker-database-init.sh:/docker-entrypoint-initdb.d/00.sh
        # mongo --host localhost \
        #     -u $MONGO_INITDB_ROOT_USERNAME \
        #     -p MONGO_INITDB_ROOT_PASSWORD --eval \
        # "db.getSiblingDB('$MONGO_INITDB_DATABASE'); \
        #   db.createUser({
        #         user: '${MONGO_INITDB_ROOT_USERNAME}',
        #         pwd: '${MONGO_INITDB_ROOT_PASSWORD}',
        #         roles: [{role: 'readWrite', db: '${MONGO_INITDB_DATABASE}'}]
        #     });"
        ## SEE: https://docs.mongodb.com/manual/tutorial/enable-authentication/#create-the-user-administrator
      environment: 
        - MONGO_INITDB_ROOT_USERNAME=root1
        - MONGO_INITDB_ROOT_PASSWORD=root1
        - MONGO_INITDB_DATABASE=my_database_name
    database-web:
      # https://hub.docker.com/_/mongo-express
      image: mongo-express
      environment: 
        - ME_CONFIG_MONGODB_ENABLE_ADMIN=true
        - ME_CONFIG_OPTIONS_EDITORTHEME="ambiance"
        - ME_CONFIG_MONGODB_SERVER=database
        - ME_CONFIG_MONGODB_PORT=27017
        - ME_CONFIG_MONGODB_ADMINUSERNAME=root1
        - ME_CONFIG_MONGODB_ADMINPASSWORD=root1
        - ME_CONFIG_BASICAUTH_USERNAME=root1
        - ME_CONFIG_BASICAUTH_PASSWORD=root1
      depends_on: 
        - database
      ports:
        - 3001:8081
```

## MySQL

```yaml
services:
    database:
      # https://hub.docker.com/_/mysql
      image: mysql
      command: --default-authentication-plugin=mysql_native_password
      restart: always
      environment:
        - MYSQL_ROOT_PASSWORD=root
        - MYSQL_DATABASE=dbmo
      volumes: 
        - ./docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d

    # https://hub.docker.com/r/phpmyadmin/phpmyadmin/
    db-web:
      image: phpmyadmin/phpmyadmin:latest
      environment: 
        - PMA_HOST=database
        - PMA_PORT=3306
        - PMA_USER=root
        - PMA_PASSWORD=root
        - MYSQL_ROOT_PASSWORD=root
      volumes: 
        # https://hub.docker.com/r/phpmyadmin/phpmyadmin/
        # https://github.com/phpmyadmin/phpmyadmin/issues/14184
        - ./docker-config.user.inc.php:/etc/phpmyadmin/config.user.inc.php
      ports:
        - 8081:80
      depends_on: 
        - database
```

## nginx

+ **docker-compose.yml**:
```yaml
version: '3.7'
services:

  # a side-car for initalizing certificates
  frontend-init:
    image: tomcat:9.0.10-jre8
    volumes:
      - ./certificates:/usr/app
    command: |
      bash -c 'bash -s <<EOF
          echo -e "EG\nSTATE\nCITY\nCOMPANY\nSECTION\nNAME\nEMAIL\n" | \
            openssl \
            req -x509 \
            -nodes -days 365 \
            -newkey rsa:2048 \
            -keyout /usr/app/selfsigned.key \
            -out /usr/app/selfsigned.crt
      EOF'

  frontend:
    image: nginx:alpine
    volumes:
      - ./certificates/:/usr/app/certificates/
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./:/usr/share/nginx/html/
    ports:
      - 3000:80
      - 443:443
```
+ **nginx.conf:**
```
events{}
http {
    server {
        listen               443;
        ssl                  on;
        ssl_certificate      /usr/app/certificates/selfsigned.crt;
        ssl_certificate_key  /usr/app/certificates/selfsigned.key;
        ssl_ciphers          HIGH:!aNULL:!MD5;
        # server_name          local.website.dev;
        # serves static files; https://www.nginx.com/resources/wiki/start/topics/examples/full/
        location /  {
            root    /usr/share/nginx/html;
            expires 1m;
        }
    }
}
```
