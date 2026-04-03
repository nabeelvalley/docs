FROM node:24 as build

# RUN apt-get update
# RUN apt-get install -y git

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
ENV NODE_ENV="production"

RUN corepack enable

WORKDIR /site

COPY package.json .
COPY pnpm-lock.yaml .
RUN pnpm install

COPY . .
RUN pnpm run
RUN pnpm build

FROM nginx:alpine

COPY --from=build ./site/_site /usr/share/nginx/html
