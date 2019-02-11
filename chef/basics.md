# Basics of Chef

[From this Module](https://learn.chef.io/modules/learn-the-basics)

## Note About Environment

I am running a VM with access to a Shared Drive using VirtualBox, this can be found at `root/media/sf_name` on my Ubuntu VM

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