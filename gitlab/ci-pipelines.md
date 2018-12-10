# CI Pipelines

## Static Site

To deploy a static site we make use of the `pages` object. Our script will make a new `public` directory and copy our site files to this directory. The `only` lists the branch from which we want our deployments to run from



```yaml
pages:
  stage: deploy
  script:
  - mkdir .public
  - cp -r * .public
  - mv .public public
  artifacts:
    paths:
    - public
  only:
  - master
```



## Angular

We have two stages from our Angular deployment

### Build

During our build stage we install our dependencies, do the application build, and expose our `dist`folder as an artifact which can be passed to our deploy stage

### Deploy

We simply copy the contents of our `dist` folder to our `public` directory. 


Note that we also need to modify our `index.html` file's base url to be `<base href="">` otherwise our app will get a 404 error when trying to get our script and css files




```yaml
build:
  image: node:latest
  stage: build
  script:
  - echo "compile"
  - npm install
  - npm install -g @angular/cli
  - npm run build
  - ls dist
  artifacts:
    paths:
    - dist
  cache:
    paths:
    - node_modules
```



```yaml
pages:
  stage: deploy
  script:
  - ls
  - echo "deploy"
  - ls dist
  - mkdir .public
  - cp -r dist/. .public
  - mv .public public
  - ls public
  artifacts:
    paths:
    - public
  only:
  - develop
```



```yaml
stages:
 - build
 - deploy

build:
  image: node:latest
  stage: build
  script:
  - echo "compile"
  - npm install
  - npm install -g @angular/cli
  - npm run build
  - ls dist
  artifacts:
    paths:
    - dist
  cache:
    paths:
    - node_modules

pages:
  stage: deploy
  script:
  - ls
  - echo "deploy"
  - ls dist
  - mkdir .public
  - cp -r dist/. .public
  - mv .public public
  - ls public
  artifacts:
    paths:
    - public
  only:
  - develop
```



```markup
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Nabeel's Blog</title>
  <base href="">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
  <app-root class="content"></app-root>
</body>
</html>

```



