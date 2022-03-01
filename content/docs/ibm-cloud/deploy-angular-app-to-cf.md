# Deploy Angular App to CF with DevOps

## Generating an Angular Application

First thing's first - before we can deploy an application, we first need to build one. For this we will be building an Angular 6 Application with the use of the **Angular CLI**. In order to do this we will need some prerequisites

### Prerequisites

* Node.js
* NPM
* Git
* Familiarity with Git and GitHub

### Building the App with the CLI

Open your Terminal/Powershell Application and navigate the directory in which you would like to create your application, then install the Anguar CLI

```text
npm install -g @angular/cli
```

Thereafter we can build the Angular Starter app by using the Angular CLI as follows, I'm going to call my application _DemoApp_, but you can name yours whatever you like, just keep this in mind as you will need to reference your app's name when configuring your deployment directory

```text
ng new DemoApp
```

If you are prompted to select options for your application select the ones you would like to use. This will create your application's files and install the required dependencies

Once that has been done you will see that the files for your application will have been placed in a newly created _DemoApp_ Directory, next we can navigate into this directory  with

```text
cd DemoApp
```

Next we will jump into GitHub and set up a new repository

### Setting up a GitHub Repo

Go the the [GitHub website](https://github.com/) and log in

Once logged into GitHub create a new repository for the application with the following options, then click **Create repository**

![Create a GitHub Repository](/docs/assets/image%20%2820%29.png)

Upon creating a new repository you will see the next screen with instructions on how to push your repository to GitHub

![Push App to GitHub](/docs/assets/image%20%2823%29.png)

For our purposes we will do the following in the terminal from the DemoApp directory, note that you can get your repository URL from the GitHub Repository Page as shown above

```text
git add .
git commit -m "first commit"
git remote add origin <YOUR REPOSITORY URL>
git push -u origin master
```

If you run into the `'git' is not recognised as an internal or external command` you can [download git here](https://git-scm.com/), then close and reopen your terminal and navigate back to your application

If you get a `fatal: not a git repository` error in your terminal, do the following instead

```text
git init
git add .
git commit -m "first commit"
git remote add origin <YOUR REPOSITORY URL>
git push -u origin master
```

Once we have done that, we can refresh the GitHub page and see our code

![Our App on GitHub](/docs/assets/image%20%2826%29.png)

## Creating a DevOps Toolchain

Next up we can log into [IBM Cloud](https://console.bluemix.net) and navigate to [DevOps](https://console.bluemix.net/devops/getting-started) from the hamburger menu at the top left

![IBM Cloud Dashboard](/docs/assets/image%20%2814%29.png)

Once on DevOps we can navigate to the **Getting Started** page via the menu on the left and click on **Get Started** button on this screen

![DevOps Getting Started](/docs/assets/image%20%2839%29.png)

From here we can search for the **Build your own toolchain** template as shown below and click on the option shown below \(note that the search is case sensitive\)

![Create a Toolchain](/docs/assets/image%20%2832%29.png)

Then we **name** our Toolchain and select the **Region,** and finally click **Create**

![Configure the Toolchain](/docs/assets/image%20%2817%29.png)

Once we've created our toolchain we will be directed to the toolchain overview which show us an overview of the different tool integrations we have  within our toolchain. At the moment we do not have any, we can click on **Add a Tool** to add the GitHub integration which will pull our code from GitHub for use within our toolchain

![Toolchain Overview](/docs/assets/image%20%2836%29.png)

### Getting our Code from GitHub

Once we are on the _Add Tool Integration_ screen, we can search for _GitHub_ and click on the **GitHub** Tool Integration

![Add Tool Integration](/docs/assets/image%20%2835%29.png)

If you are prompted to Authorize this tool, click on the **Authorize** button and follow the instructions on the window that appears before moving on

Next we will configure our integration by selecting our **GitHub Server**, in this case _GitHub_, then our **Repository Type** as _**Exisitng**_, then search for our **Repository URL** and select the one that contains the app we would like to deploy, in this case _AngularDemoApp_, then click **Create Integration**

![Configure the GitHub Integration](/docs/assets/image%20%2837%29.png)

Upon creating our tool integration we will be directed back to our toolchain overviewwhere we can see the two tools that the GitHub integration has added, the **Issues** tool, and the **GitHub** tool

![GitHub Toolchain](/docs/assets/image%20%2813%29.png)

Next we will click on **Add a Tool** again to create a Delivery Pipeline

### Creating a Delivery Pipeline

On the Add Tool Integration screen search for **Delivery Pipeline**, and create a Delivery Pipeline by clicking on the Delivery Pipeline option as shown below

![Add Delivery Pipeline](/docs/assets/image%20%2828%29.png)

This will direct us to the Tool Configuration page, in which we set our **Pipeline Name**, and click **Create Integration**

![Configure the Integration](/docs/assets/image%20%2811%29.png)

Once we have done that we will see Delivery Pipeline on our dashboard

![Final List of Tools](/docs/assets/image%20%2810%29.png)

Click on the **Delivery Pipeline** tool on the dashboard so that we can begin to set up the different stages of our pipeline

When we click on the Delivery Pipeline Tool we will be taken to our pipeline stages \(which at this point has no stages\) and we can click on **Add a Stage**

![Toolchain Overview](/docs/assets/image%20%2827%29.png)

### Build Stage

First we will add a stage for building our Application, we will **name** this stage _Build Application_, and set up our input. Select an **Input Type** of _**Git Repository**_, and ensure that the correct repository is selected, as well as the **Master** branch 

![Configure Build Stage](/docs/assets/image%20%285%29.png)

Next scroll back up and click on **Jobs** then add a Build Job to our stage

![Create a Build Job](/docs/assets/image%20%289%29.png)

And select our **Builder Type** as _**npm**_

![npm Build Type](/docs/assets/image%20%2838%29.png)

We also need to change our **Build Script**  as is shown below, this will install the version of node that our application will need, install our app dependencies and do a production build for our application.

```text
#!/bin/bash
export NVM_DIR=/home/pipeline/nvm
export NODE_VERSION=8.12.0
export NVM_VERSION=0.29.0

npm config delete prefix \
  && curl https://raw.githubusercontent.com/creationix/nvm/v${NVM_VERSION}/install.sh | sh \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  && node -v \
  && npm -v

npm install -g @angular/cli
npm install

ng build --prod
```

If you would like to view an explanation of the general version installation process you can see that on  [**Michael Wellner's Blog**](http://gh-blog.mybluemix.net/blogs/cokeSchlumpf/rethink-it/posts/bluemix/node-buildpipeline.md?cm_sp=dw-bluemix-_-nospace-_-answers)

Next we need to select the correct **Build Archive Directory**

```text
dist/DemoApp
```

If you did not name your Application _DemoApp_ then select your BuildArchiveDirectory with

```text
dist/<YOUR APP NAME>
```

![Build Script and Build Directory](/docs/assets/image%20%2834%29.png)

Once we are done with that we can click **Save** which will take us back to our Delivery Pipeline stage view

![Delivery Pipeline with Build Stage](/docs/assets/image%20%2818%29.png)

From here click **Add a Stage** to create a stage for deployment

### Deploy Stage

Rename our stage to **Deploy** and ensure that our **Input Type** is _**Build Artifacts**_, that the **Stage** is set to _**Build Application**_ \(or whatever we named our build stage\), and the **Job** is the _**Build**_ job from our previous stage

![Deploy Stage Configuration](/docs/assets/image%20%2815%29.png)

Click on the **Jobs** tab and add a **Deploy** Job then set our **Deployer Type** as _**Cloud Foundry**_, our **IBM Cloud Region** as the region in which our Organization and Space are located, our **Organization**, and **Space** in which we want our App Resource to be in, and then our **Application Name** for our Cloud Foundry Application

![Deploy Job Creation](/docs/assets/image%20%2819%29.png)

Lastly we need to set our **Deploy Script.**  For this we will use the `cf push` command with the **Static File** buildpack as Angular Applications are built to a static web-page. Furthermore we use the `--hostname` option to set the route for our application as well as the `--no-manifest` option. The script we will use can be seen below.  The hostname can be anything you like, this will be the route through which your application/website will be accessed

```text
#!/bin/bash
cf push "${CF_APP}" --hostname <YOUR HOSTNAME> --no-manifest -b 'https://github.com/cloudfoundry/staticfile-buildpack'
```

If we would like to restrict the memory usage of our application we can use the `-m` flag as follows:

```text
#!/bin/bash
cf push "${CF_APP}" --hostname <YOUR HOSTNAME> --no-manifest -m 256M -b 'https://github.com/cloudfoundry/staticfile-buildpack'
```

![Deploy Script Configuration](/docs/assets/image%20%283%29.png)

Once that's done we can click **Save** which will take us to our Delivery Pipeline Stage view

The App Manifest allows us to set our application configuration via a manifest file as opposed to via the CLI, you can find more information about [Cloud Foundry Manifests here](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html)

## Doing a Deployment

We run our **Build Application** stage via the **Play Button** at the top right of the card, this will in turn trigger the **Deploy Stage** once it has completed

![Complete Delivery Pipeline](/docs/assets/image%20%281%29.png)

When our Build and Deploy have completed successfully we will see the following

![Build and Deployment Completed Successfully](/docs/assets/image%20%2822%29.png)

If the stages are red this means that one of them have failed, we can view the logs by clicking on the **Build** or **Deploy** Stages or clicking on **View logs and history**, this will allow us to troubleshoot any issues we may have encountered in either of our stages

Note that as we update our application **master** branch **GitHub** our _Build_ and _Deploy_ stages will be run automatically

## View our Application

We can navigate to our **IBM Cloud Dashboard** via the hamburger menu at the top left or by clicking on **IBM Cloud** in the Menu Bar at the top of the screen, here we will see our newly created application

![Our Application Resource on the Dashboard](/docs/assets/image%20%2831%29.png)

We can click on our application to get to the application screen where we can view our application information as well as modify the number of **Instances** or **Instance Memory** as well as other information about our application from the menu on the left

![Application Resource Screen](/docs/assets/image%20%2825%29.png)

Lastly we can open our Application Site via the **Visit App URL** link at the top

![Our Application](/docs/assets/image%20%2816%29.png)

And you're done! You have successfully **built** and **deployed** an Angular Application with **IBM Cloud DevOps**

  




