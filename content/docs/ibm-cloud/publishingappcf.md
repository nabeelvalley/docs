# Publish an App to CF

Every app to be published requires a `manifest.yml` file that defines some specifications for the app. An example of this can be seen below:

```text
declared-services:
    service-name:
        label: Service Name
        plan: free
applications:
    name: unique-name-for-application
    path: .
    memory: 500M
    instances: 1
    services: 
    - Service Name
    env:
    NODE_ENV: dev
```

## Setting Up Credentials

We make use of the `.env` to store the relevant API Keys for the services that out application will be using

## Pushing an app to the cloud

The `bx` CLI is used to publish an app to the IBM cloud.

1. Configure our api endpoint `bx api https://api.eu-gb.bluemix.net` \(or another endpoint if you're using a different server location, **obviously**\)
2. Next you log in with `bx-login`, however if you have a federated login then you need to make use of `bx login -sso`
3. `bx target cf` will enable us to select the _space_ and _organization_ that we want to publish to
4. Then we can push our app with `bx app push` which will upload our package, create a container and then deploy the container

