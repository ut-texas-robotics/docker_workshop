# Docker for Robotics Workshop

This repo contains exercises and supporting documentation for the workshop held on November 3, 2023.

## Install Docker Software

- [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Install NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- [Post-Installation Steps](https://docs.docker.com/engine/install/linux-postinstall/)
- [Plugin: docker sbom](https://github.com/docker/sbom-cli-plugin)

Follow the instructions at the links above to install Docker Engine for ubuntu, the NVIDIA Container Toolkit if you are using an nvidia graphics card and drivers, and the docker sbom plugin.  Use the apt repository installation methods.  Be sure to follow the post-installation steps if you want to run docker without `sudo`.

Be careful not to install Docker Desktop -- this workshop does not use it.  Docker interacts with the Linux kernel, and for the purposes of this workshop we will be working on computers with a native linux OS only.  Docker for Windows and Mac both run Docker inside of a VM, and handling that is outside of the scope of this lesson plan.

## Exercise 1: Exploring Images and Containers

### 1.01 Pull an image from a registry
Visit [Docker Hub](https://hub.docker.com/_/ubuntu) to see the official ubuntu images and the tags you can use to pull one to your machine.  Open a terminal use the pull command to retrieve the image tagged with your desired version from the registry.  If you don't use a tag, you will pull the one labelled `ubuntu:latest` by default.
```
docker pull ubuntu:22.04
```

See this new image in the list of images on your system:
```
docker image ls
```

### 1.02 Inspect the contents of an image
Often its useful to see the contents of an image or get some metadata about its build.  Several commands are helpful for this: `docker inspect`, `docker sbom` and `docker history`.

```
docker inspect ubuntu:22.04

---
Returns a json style output with details like when the image was made, labels and tags, what layers certain components exits on, and more.
```
In 2022, the `docker sbom` plugin was introduced at Docker Con, and while it is still considered experimental, it provides a very useful list of the "Software Bill of Materials", or installed packages in an image.
```
docker sbom ubuntu:22.04

---
Returns a list of the installed packages.  You can also output to a file, or format in syft-json, which contains for details about what layer resources exist on.

```
History will show a Dockerfile command history in each image.  For base images, often there is not an included history, but as you build images you will find more details in the output.
```
docker history ubuntu:22.04
```

### 1.03 Explore the container
Running containers from images is very simple.
```
docker run -it ubuntu:22.04
```

This creates the ubuntu container.  `-i` or `--interactive` keeps STDIN open and `-t` or `--tty` allocates a psuedo TTY terminal interface with the container.

Get your bearings in this container.  Take a look at the user, where you are in the directory structure and where your home directory is:
```
ls
cd $HOME
`pwd`

exit
```
After exiting the container do:
```
docker ps

docker ps -a
```
The container is not in the list of running containers, but it is still on our system.  See that it has an id and a randomly generated name.

```

docker start <container_id>

docker exec -ti <container_name> /bin/bash
```