# Ubuntu

## Troubleshooting

### Temporary failure resolving ...

> See [this answer](https://askubuntu.com/questions/91543/apt-get-update-fails-to-fetch-files-temporary-failure-resolving-error)

When trying to run the `apt-get update` command you may encounter an error with some domains not resolving, may be due to the DNS resolution not working as it should. In order to fix this, manually add a DNS Server Entry which will work as a temporary fix:

```
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
```

Or permanently add one in the event this is an ISP Level issue (unlikely):

```
echo "nameserver 8.8.8.8" | sudo tee /etc/resolvconf/resolv.conf.d/base > /dev/null
```

You should then be able to run:

```
sudo apt-get update
```
