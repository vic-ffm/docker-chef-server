# Chef Server

[![](http://dockeri.co/image/stocksoftware/chef-server)](https://hub.docker.com/r/stocksoftware/chef-server)
[![Build Status](https://secure.travis-ci.org/stocksoftware/docker-chef-server.png?branch=master)](http://travis-ci.org/stocksoftware/docker-chef-server)

A docker image running Chef 11 published. Run via:

    $  docker run -it --name chef_server -p 80:80 -p 443:443 stocksoftware/chef-server

## Prerequisites

The `kernel.shmmax` and `kernel.shmall` sysctl values should be set to
a high value on the host. 

## Environment Variables

- `PUBLIC_URL` - should be configured to a full public URL of the endpoint (e.g. `https://chef.example.com`)

## Ports

Ports 80 (HTTP) and 443 (HTTPS) are exposed.

## Volumes

`/opt/chef-server/backups` is a volume that holds backups of chef data.

## Signals

 - `docker kill -s HUP $CONTAINER_ID` will run `chef-server-ctl reconfigure`
 - `docker kill -s USR1 $CONTAINER_ID` will run `chef-server-ctl status`

## First 


First start will automatically run `chef-server-ctl reconfigure`. Subsequent starts will not run
`reconfigure`, unless file `/var/opt/chef-server/bootstrapped` has been deleted. If you edit `chef-server.rb`
then you can run `reconfigure` via  `docker exec` or by sending SIGHUP to the container: `docker kill
-HUP $CONTAINER_ID`.

### Backups

The backups occur to the volume `/opt/chef-server/backups` and can be run via;

    $ docker exec chef-server /opt/chef-server/embedded/bin/backup

## Credits

The project is heavily inspired by [3ofcoins/docker-chef-server](https://github.com/3ofcoins/docker-chef-server).
All credit goes to the original authors.
