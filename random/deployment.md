# Deployment Platforms

This note is here just so I can remember everything

## [Now by Zeit](https://zeit.co/)

This is a single click application deployment platform capable of deploying apps of a few different languages, Docker containers were the big thing for me but they seem to have removed that

Now has a desktiop application as well as a CLI that can be used

Can be installed with

```bash
npm install -g now
```

If you run into trouble you may be asked to install it instead with

```bash
npm install -g now --unsafe-perm
```


And applications can be deployed with the following command, assuming you have a correctly configured `now.json` file

```bash
now
```

## Heroku

Deploying applications to heroku makes use of either a Procfile, package.json, or a Docker Imgage

For the Package.json deployment you need only do the following from the root directory of your app:

1. Specify the start script if your application is in the root, otherwise, in my case the following is what I did

```json
{
  "scripts": {
    "start": "cd server && ls && yarn install && node index.js"
  }
}

```
2. Log in with Git

```bash
heroku login
```

3. Push the latest commit

```bash
git push heroku
```

Using Docker the process is also fairly simple (aside from the fact that you need to build the application locally and push the image)

1. Build the docker image from the directory
2. Log in to Heroku

```bash
heroku login
```

3. Log in to the Container Registry

```bash
heroku container:login
```

4. Push the image, note that the `web` refers to the runner and not the app name

```bash
heroku container:push web
```

5. Deploy the image

```bash
heroku container:release web
```

## [CodeFresh](https://g.codefresh.io)

Codefresh provides a CI platform for Pipelines for DOcker, k8s, Helm, etc.

## Cloud Foundry (IBM Cloud)
## Digital Ocean