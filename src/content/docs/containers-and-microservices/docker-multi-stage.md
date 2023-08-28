---
published: true
title: Multi Stage Docker Builds
---

---
published: true
title: Multi Stage Docker Builds
---

A multi stage build is pretty much what it sounds like - It is a docker build which can have multiple stages capable of inheriting material from one another. Using this method an image, while being built, has access to a shared file system from the other image

In the below image on the first line we can see that we create the initial image using `FROM node:8` and call it `install-packages`. Therefter we install the application dependencies. Next in the production stage we start to build the second image, `FROM node:8` once again, however note that in the `COPY` lines we make use of a `--from=install-packages` flag which indicates that we should copy the files from the `install-packages` image instead of the local machine as we normally would do. The resulting image is the Production image. The Installation phase layers are discarded hence resulting in a smaller overall image without the unecessary build dependencies

```Dockerfile
# Install Node Modules
FROM node:8 as install-packages

COPY app/package.json ./app/package.json
COPY server/package.json ./server/package.json

WORKDIR /app
RUN yarn

WORKDIR /server
RUN yarn

WORKDIR /
COPY app ./app

WORKDIR /app
RUN yarn build

# Build Production Image
FROM node:8

WORKDIR /
COPY --from=install-packages app/build ./app/build
COPY --from=install-packages server ./server
COPY server server

WORKDIR /server
EXPOSE 3001
CMD ["node", "index.js"]
```
