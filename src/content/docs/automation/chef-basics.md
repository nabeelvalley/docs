---
published: true
title: Basics
subtitle: Basic Concepts for using Chef
---

[[toc]]

# Basics of Chef

[From this Module](https://learn.chef.io/modules/learn-the-basics)

```
Infrastructure Automation > Learn the Basics > Ubuntu > Docker
``` 

## Note About Environment

I am running a VM with access to a Shared Drive using VirtualBox, this can be found at `root/media/sf_name` on the Ubuntu VM

## Set Up a Docker Container to Manage

We'll make use of a Docker container with Ubuntu to work with Chef - generally though Docker containers are treated as immutable infrastructure

Before starting we will need to ensure that Docker is installed on our system so that we can run chef in the container

### Make a Working Directory

Make a new directory in which we can work

```bash
mkdir learn-chef
cd learn-chef
```

### Start the Docker Container

Download the Ubuntu 14.04 image from Docker hub and start the container

```bash
docker pull ubuntu:14:04
```

From the shared `learn-chef` directory, run the following command

```bash
$ docker run -it -v $(pwd):/root/chef-repo -p 8100:80 ubuntu:14.04 /bin/bash
```

```powershell
PS> docker run -it -v ${pwd}:/root/chef-repo -p 8100:80 ubuntu:14.04 /bin/bash
```

Running the container as above will expose also give our docker container access to our system `~ /chef-repo` directory so that we can edit our chef code directly from there

### From the Container

Update the container package list and install curl

#### Install Chef in Container

```bash
apt-get update
apt-get install curl -y
```

Next we can run Chef Workstation as follows:

```bash
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chef-workstation -c stable -v 0.2.41
```

#### Set Up the Working Directory

From the container `cd` into the `~/chef-repo` directory that we initialized previously

In this directory (the same as your local `learn-chef`) directory, create the initial MOTD file by using `chef-client` in local mode (usually `chef-client` will download the latest code from a server though)

Inside of the `chef-repo` directory create a file called `hello.rb` with the following content

```rb
file '/tmp/motd' do
  content 'hello world'
end
```

And then run the above file with the following command

```bash
chef-client --local-mode hello.rb
```

This will create a new file `/tmp/motd` which contains the text `hello world`

We can view the contents of this file using `more` or `cat`

```bash
more /tmp/motd
```

If we run the `chef-client` command again we will see that no resources were updated

We can update the `hello.rb` file contents to contain the following

```rb
file '/tmp/motd' do
  content 'hello chef'
end
```

And then update the resource with 

```bash
chef-client --local-mode hello.rb
```

And we will see that the file was updated with the following

```
- update content in file /tmp/motd from b94d27 to c38c60
--- /tmp/motd	2019-02-11 14:47:29.431735359 +0000
+++ /tmp/.chef-motd20190211-4014-8rvcal	2019-02-11 14:53:48.291735359 +0000
@@ -1,2 +1,2 @@
-hello world
+hello chef
```

If we manually change the `/tmp/motd` file, running `chef-client` will restore the correct configuration

You can test this by running the following command to modify the file

```bash
echo 'hello robots' > /tmp/motd
```

And then having chef restore it

```bash
chef-client --local-mode hello.rb
```

Chef endsures that the actual state of a resource matches the state that was specified, even if it is altered by an external resource. Usually we configure `chef-client` to run periodically or as part of a continuous automation system which helps our resources be correctly configured

#### Delete MOTD file

Create a file called `goodbye.rb` with the following contents

```rb
file '/tmp/motd' do
  action :delete
end
```

Then use the `chef-client` to run it

```bash
chef-client --local-mode goodbye.rb
```

This will give us the following output

```
Recipe: @recipe_files::/root/chef-repo/goodbye.rb
  * file[/tmp/motd] action delete
    - delete file /tmp/motd
```

```bash
more /tmp/motd
#/tmp/motd: No such file or directory
```

### Summary

Resources describe the what, not the how. A recipe is a file that describes what state a part of the system should be in, but not how to get there - that is handled by Chef

Resources have actions, such as `:delete` which is a process by which a desired state is reached. Every resource has a default action, such as *create a file* or *install a package*. `:create` is the defult action for a `file` resource

Recipes are an ordered list of configuration states and typically contain related states

## Configure a Package and Service

Packages and services, like files, are also resource types

For this portion we will be managing an Apache HTTP Server Package and its associated Service

### Update Apt Cache

We can run the `apt-get update` command manually every time we bring up an instance, but chef provides us with an `apt_update` resource to automate the process

Chef allows us to periodically carry out a specific task, in this case we can update our apt cache every 24 hours (86 400 seconds)

In the `chef-repo` directory create a `webserver.rb` file with the instructions to periodically update the cache as follows

```rb
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end
```

Instead of `:periodic` we can also use the `:update` action to update each time chef runs

### Install the Apache Package

Next we can install the `apache2` package, modify the `webserver.rb` package to do this

```rb
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'apache2'
```

We don't need to specify the `:install` action as this is the default


Now run the recipe with

```bash
chef-client --local-mode webserver.rb
```

Typically (if not the `root` user) we need to run Chef with `sudo`

### Start and Enable the Apache Service

Update the `webserver.rb` file to enable the Apache service when the server boots and then start the service, this is one by way of the `action` list given in which the following actions on a resource will be carried out

```rb
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'apache2'

service 'apache2' do
  supports status: true
  action [:enable, :start]
end
```

Now re-run the recipe in order to start the service

```bash
chef-client --local-mode webserver.rb
```

### Add a Home Page

We can use the `file` resource to create a homepage for our site at `/var/www/html/index.html` with a basic hello world message. This can be added to the `webserver.rb` recipe as follows

```rb
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'apache2'

service 'apache2' do
  supports status: true
  action [:enable, :start]
end

file '/var/www/html/index.html' do
  content '<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>'
end
```

And we can run `chef-client` to apply it

```bash
chef-client --local-mode webserver.rb
```

If we do not see any errors we can continue and make an HTTP request with `curl` inside the container, making a `curl` to `localhost` will by default hit port `80`, we can do this from the container as follows

```bash
curl localhost
```

Or

```bash
curl localhost:80
```

Furthermore we can view this on the host machine's browser due to the port forwarding we initially set up for the container `-p 8100:80 ` on which maps port `80` on the container to `8100` on the host. We can do this simply by visiting `localhost:8100` from the host or making an HTTP request from the terminal

### Summary

Chef allows us to automate and configure multiple resource types as well as carry out tasks periodically, manage installed packages, and specify actions for those packages

## Making Recipes More Managable

The problem with the recipe we are currently using is that the HTML for the webpage was embedded in the recipe, this is not practical. In order to more easily reference external files we can make use of a Cookbook

### Create a Cookbook

From the `chef-repo` directory create a `cookbooks` directory, in this run the use Chef to generate a Cookbook named `learn_chef_apache2`

```bash
mkdir cookbooks
chef generate cookbook cookbooks/learn_chef_apache2
```

The `cookbooks/learn_chef_apache2` part tells chef to create a new Cookbook in the `cookbooks` directory called `learn_chef_apache2`

Thereafter install `tree` on the container so that we can view the directory structure and then look at the `cookbooks` directory

```bash
apt-get install tree -y
tree cookbooks
```

The file structure can be seen to be:

```
cookbooks
`-- learn_chef_apache2
    |-- Berksfile
    |-- CHANGELOG.md
    |-- LICENSE
    |-- README.md
    |-- chefignore
    |-- metadata.rb
    |-- recipes
    |   `-- default.rb
    |-- spec
    |   |-- spec_helper.rb
    |   `-- unit
    |       `-- recipes
    |           `-- default_spec.rb
    `-- test
        `-- integration
            `-- default
                `-- default_test.rb
```

The default recipe is in the `recipes/default.rb` file, our recipe will be written in there

### Create a Template
A new template file can be generated with the `chef generate` command, generate a new template called `index.html` as follows

```bash
chef generate template cookbooks/learn_chef_apache2 index.html
```

Move the `index.html` content we made previously to a `template` file which will be added as `templates/index.html.erb` into which we must add the following

```html
<html>
  <body>
    <h1>hello cookbook</h1>
  </body>
</html>
```

> We have added the content directly into the cookbook for the purpose of the tutorial, but realstically the application would be some set of build artifacts that will then be pulled from a build server to be deployed

### Update the Recipe

Now update the recipe in the `default.rb` file to once again update the apt cache, start the Apache Web Server, and reference the HTML template with the following

```rb
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'apache2'

service 'apache2' do
  supports status: true
  action [:enable, :start]
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end
```

### Run the Cookbook

`chef-client` can be used to run the Cookbook, we will again use the `--local-mode` flag and specify the required recipes with the `--runlist` flag

```bash
chef-client --local-mode --runlist 'recipe[learn_chef_apache2]'
```

Note the `recipe[learn_chef_apache2]` which specifies that we want to run the `learn_chef_apache2`'s `default.rb` recipe. This is the same as `recipe[learn_chef_apache2::default]`

We can check that the file was updated with

```bash
curl localhost
```

And by visiting `localhost:8100` on the Host

