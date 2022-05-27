[[toc]]

# Setup GitLab SSH for Git

You need to run the following from bash:

```
ssh-keygen -t rsa -b 4096 -C "you@email.com"
cd .ssh/
cat id_rsa.pub
```

Then copy the key displayed on your screen and add a new key on GitLab [here](https://gitlab.com/profile/keys)
