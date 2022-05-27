[[toc]]

# Considerations

To run MongDB in a Docker Container there are a few things to take note of:

- You may need to configure auth
- Volume storage to be set up

# From Terminal

To run a Docker container using a single command in the terminal you can run the following command:

```sh
docker run -d -p 27017:27017
```

You can also specify additional information like the volumes you would like to use using flags when running:

```sh
docker run -d -p 27017:27017
```

# From Compose

> More info can be found [here](https://medium.com/faun/managing-mongodb-on-docker-with-docker-compose-26bf8a0bbae3)

You can also run a MongoDB Container with Compose which may be a bit easier:

`docker-compose.yml`

```yml
version: '3.3'

services:
  # mongonode0:27017
  mongo0:
    image: mongo
    hostname: mongo0
    container_name: mongo0
    restart: always
    ports:
      - '37000:27017'
    volumes:
      - ./mongo0-data:/data/db
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: password
```
