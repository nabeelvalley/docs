---
title: nginx
description: Basic nginx stuff
---

> Before getting started you'll need to install nginx which can be done on the [nginx website](https://nginx.org/). Additionally these notes mostly take a walk through the [beginner's guide](https://nginx.org/en/docs/beginners_guide.html) as well as this [NGINX Crash Course](https://www.youtube.com/watch?v=7VAI73roXaY)

## Overview

nginx is an HTTP web server, reverse proxy, and a bunch of other related technologies

nginx consists of a single masster process and serveral workers. The master processs reads configuration and manages worker processes. The root nginx config is named `nginx.conf` and can be found in one of the default config directories

You can see the help menu using:

```sh
nginx -h
```

## Basic lifecycle commands

> If you run into issues with some of the nginx commands try running them with `sudo`

Starting and stopping the nginx service (this depends on your installation)

```sh
brew services start nginx # start nginx service

brew services stop nginx # stop nginx service

brew services restart nginx # restart nginx service
```

And some other basic commands for interacting with nginx using the `nginx` installation:

  
```sh
nginx -s stop # fast shutdown

nginx -s quit # graceful shutdown

nginx -s reload # reload config

nginx -s reopen # reopen log files
```

### Config file

The nginx config consists of modules that are controlled by directives. Directives can be a semicolon or block delimited. Some block directives can have other blocks within them, these are called contexts. Any directive placed outside of a context are considered to be within the main context

You should be able to find the link  to the default config file by doing `nginx -h` and looking at the `-c` option's description

> Comments use `#`

The default config looks like this:

`nginx.conf`

```conf
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       8080;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
    include servers/*;
}
```

### Serving Static Content

Replace the above file with this to end up with the minimal config below:

```conf
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    server {
        location / {
            root data/www;
        }
   
        location /images/ {
            root data;
        }
    }
}
```

> The `root` path can also be an absolute path instead of relative to the configured prefix path

After modifying the config, you can use nginx to verify the configuration:

```conf
nginx -t
```

Next, we can add the following files to the nginx `--prefix` directory which can be found with `nginx -V`:

```
data
├── images
│   └── image.jpg
└── www
    └── index.html
```

You can then reload your config with:

```sh
nginx -s reload
```

In the above config we have not set a port for our server, this means that the server we have is listening on port 80 and can be accessed at `http://localhost:80`, the image can be reached from `http://localhost:80/images/image.jpg`


An nginx config can have multiple `server` blocks which can listen on different ports. In the config we have above the evaluation of the route is processed by:

1. Looking at the URI and comparing it to the one in the `location`
2. nginx selects the longest matching locaiton
3. The URI is then appended to the `root` to resolve the final path on the file system

#### Aliasing

In the event we don't want the URI to be appended to our path we can use an alias, so for example we can make it so that `/hello` points to the index as well:

```conf
location /hello {
    alias data/www;
}
```

#### Try Files

In the event the requested file is not found we can provide some fallbacks that can be looked at instead using `try_files`:

```conf
location /images/ {
    root data;
    try_files /images/image.jpg /images/index.html =404;
}
```

In the above config, `try_files` will check the given files in order, if none of those exist, it will return a 404

#### Regex locations

Locations can also use a regex, for example using the `/count` route:

```conf
location ~* /count/[0-9] {
    root data/www;
    try_files /index.html =404;
}
```

The above will make it so that we fallback to the `index.html` file if it exists when given any URI that matches the regex

#### Redirects

Redirect allow us to tell the requestor to visit another URL instead, redirects are done simply via the `return` with some status and path

```conf
location /redirectme {
    return 307 /images/image.jpg;
}
```

#### Rewrites

Rewrites allow us to send the response from one path to another, this works by providing some regexes and replacements:

```conf
rewrite ^/number/(\w+) /count/$1;

location ~* /count/[0-9] {
    root data/www;
    try_files /index.html =404;
}
```

That will rewrite the response from `/number/<NUM>` to `/count/<NUM>` and handle the `count` location as seen above

### Proxying

Setting up a proxy server can be done using the `proxy_pass`. For example we can add a server listening on port `8080` to the http block we have that proxies any requests to the image location to the server we have on port `80`

```conf
server {
    listen 8080;
    
    location / {
        proxy_pass http://localhost:80/images/;
    }
}
```
Reloading nginx with `nginx -s reload` should apply the configuration and you should be able to view an image at `http://localhost:8080/image.jpg`

### Mime Types

By default nginx doesn't serve content with the appropriate mime types, we can configure this by defining a `types` block within the `http` context, for example we can define a custom mime type for some made up formats:

```conf
types {
    text/html        html;
    text/alpha       abc;
    text/numeric     123;
}
```

There are also a bunch of builtin mime types. We can find these in the `mime.types` file inside of the nginx config directory

The default `mime.types` file can be included into our existing config by using `include` with the path to the file we want to include:

```conf
http {
    include mime.types;

    # ... other stuff
}    
```

### Load Balancing

Load balancing can be done by specifying some URLs in an `upstream` block along with a name, and we can then reference that name using a `location` with a `proxy_pass`:

```conf
http {
    
    upstream mybackendserver {
        server 123.0.0.1:8081;
        server 123.0.0.2:8082;
        server 123.0.0.3:8083;
    }

    server {
        location / {
            proxy_pass http://mybackendserver/;
        }
    }
}
```
