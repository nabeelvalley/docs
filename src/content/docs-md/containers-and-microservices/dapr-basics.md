# What is Dapr?

> Abbreivation for "Distributed Application Runtime"

Dapr is a runtime/framework for developing event-driven microservices and cloud-native applications

Dapr can be installed by following the relevant instructions from [the documentation](https://docs.dapr.io/getting-started/install-dapr-cli/)

# Getting Started

When using Dapr it's recommended that you also have Docker installed

Dapr works by deploying sidecar containers that manage communication and service invocation between services

To initialize Dapr you can run the following command to download the required binaries and config as well as start some of the required Docker containers:

```sh
dapr init
```

Thereafter, you can view the running containers that Dapr has initialized with:

```sh
docker ps
```

```raw
CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS                    PORTS                              NAMES
365529eb2137   daprio/dapr         "./placement"            19 minutes ago   Up 19 minutes             0.0.0.0:6050->50005/tcp            dapr_placement
86802da99f48   redis               "docker-entrypoint.s…"   20 minutes ago   Up 20 minutes             0.0.0.0:6379->6379/tcp             dapr_redis
0affbb4ed6d0   openzipkin/zipkin   "start-zipkin"           20 minutes ago   Up 20 minutes (healthy)   9410/tcp, 0.0.0.0:9411->9411/tcp   dapr_zipkin
```

And you can verify if the `components` directory was created

```sh
ls ~/.dapr
```

```raw
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         3/26/2021   5:47 PM                bin
d-----         3/16/2021   4:10 PM                components
-a----         3/16/2021   4:10 PM            187 config.yaml
```

# Run a Component

To run an application/component on Dapr, you use the `dapr run` command

Running the default Dapr components without actually running any other application can be done with:

```sh
dapr run --app-id myapp --dapr-http-port 3500
```

Which will run a blank app which only makes use of the default dapr `redis` and `zipkin` components as is defined in the `~/.dapr/components` directory we saw above

Based on the default `redis` state store component that's defined in the Dapr instance, we can access the state store on `http://localhost:3500/v1.0/state/statestore`

Using this we can `POST` some key-value pair data to the endpoint, and retrieve it with the `key`

So to add something to the state store we can make the following HTTP Request by sending a collection of data:

```http
POST /v1.0/state/statestore HTTP/1.1
Host: localhost:3500
Content-Type: application/json
Content-Length: 65

[
    {
        "key": "init_post",
        "value": "Hello, World!"
    }
]
```

We can then retreive the data we sent with:

```http
GET /v1.0/state/statestore/init_post HTTP/1.1
Host: localhost:3500
```

Which will respond with:

```raw
"Hello, World!"
```

We can also log into `redis` from Docker to view all data in the Redis instance with:

```sh
docker exec -it dapr_redis redis-cli
```

And then we can run the following command to view the data in Redis:

```sh
> keys *

1) "myapp||init_post"
```

To view the type of the value that Dapr saves the data as:

```sh
> type "myapp||init_post

hash
```

Since the type is `hash` we need to use `hgetall` to get the value

```sh
> hgetall "myapp||init_post"

1) "data"
2) "\"Hello, World!\""
3) "version"
4) "1"
```

Additionally, Dapr apps are managed using components which are defined using `yml`, there are a number of Quickstart guides on this [here](https://github.com/dapr/quickstarts)
