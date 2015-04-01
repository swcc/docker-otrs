OTRS *Docker* container
==================================

[![Docker Hub](https://img.shields.io/badge/docker-swcc%2Fdocker--otrs-blue.svg?style=flat)](https://registry.hub.docker.com/u/swcc/docker-otrs/)

This project creates a Docker container with full OTRS stack installed (PERL app with a MySQL database).

Requirements
------------
You need a recent `docker` version installed, take a look [here](https://docs.docker.com/installation/) for instructions.

Then, simply:
```shell
$ docker pull swcc/docker-otrs
$ docker run -t -p 80:80 swcc/docker-otrs
```

This will download and run a container with a working OTRS.


Usage
-----
After starting the container, your OTRS instance is ready to be setup.
You can reach the web setup by pointing your browser to the IP address of your Docker host: `http://<host IP>:80/installer.pl`


Persist data
------------
You can mount the data and log directories to store your data outside of the container:

```shell
$ docker run -t -p 80:80 -v /otrs/data:/var/lib/mysql/otrs -v /otrs/data:/var/log/otrs swcc/docker-otrs
```


Build
-----
To build the image from scratch run

```shell
$ docker build -t otrs .
```
