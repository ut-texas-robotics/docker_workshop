# Use the Docker Development Environment

The `Docker/` directory contains setup files for a general robotics development environment.  Use the knowledge you gained in this workshop to edit the files for your own robot application.

There are two configurations available:

- the `main` branch of this repo uses the dafualt user root in the container
- the `host_user` branch creates your user in the container and works from the container's `/home/$USER`, rather than `/root`. 

## Setup

Clone the repo and source the bash utilities for simplified docker commands:
```
git clone https://github.com/ut-texas-robotics/docker_workshop.git
cd docker_workshop
echo "export ROSD_DIRECTORY=$(pwd)" >> ~/.bashrc
echo "source $ROSD_DIRECTORY/Docker/bash_utils" >> ~/.bashrc
```

## Customize your Image

Edit the Dockerfile `FROM` instruction to use an image suitable for your application.  Maybe its another version of ROS, or maybe you want to use CUDA and start with one of the `nvidia/cuda` images.  Whatever it is, you can find images on [Docker Hub](https://hub.docker.com/).

Then update the packages installed in the `RUN` instructions to get the dependencies you need.  Be sure to update the `ROS_DISTRO` environment variable for other versions of ROS.  Refer to [installing_ros_packages](./installing_ros_packages.md) for help.

## Customize your Configuration

Edit `Docker/docker-compose.yaml` for your own system.  In particular, update the `devices:` with the ones your robot uses.  Ethernet devices do not need to be added, as they are accessible via your host network.  You can also change the name of your image and the container created from it, just be sure to update `Docker/bash_utils` with the new name to use the shortcut commands below.

Edit your project directory: create a folder on your host system called `docker_projects` or something similar.  Then put the full path in `volumes:` to bind that directory to your container.
```
  volumes:
    - /full/path/to/dir:/root/projects
```

## Customize your Script

Optionally, add to `Docker/entrypoint.sh` to change the script that runs when the container starts.

## Build and Run

This container is meant to be run with the bash_utils functions.  If you don't use them, be sure to give docker xhost permissions with 
```
xhost +local:docker
```

Build the docker image with
```
rosd-build
```

Run the container and open a shell inside it
```
rosd-start
rosd-shell
```

Here is the full set of commands defined in `Docker/bash_utils`:

| Command | Function |
| --- | --- |
| `rosd-build` | build the container from docker files |
| `rosd-start` | gather host user info, apply ownership to the host user, start container in detached mode |
| `rosd-stop` | stop container and remove it |
| `rosd-shell` | open a bash shell in the container |
| `rosd-log` | view the docker container log |
| `rosd-dir` | export the ROSD_DIRECTORY env variable, usage: `rosd-dir <path>` |

To use docker commands, see the cheatsheets in `docs/` or visit the official Docker Docs.

## Start Developing

Open your code on your host in an editor like Visual Studio Code.  Work from your local `docker_projects` directory - from there, add github repos, create catkin workspaces, etc.  The contents of this directory will be available inside the container.

It is recommended to edit code and manage git from this directory on the host, and use the container to build and run the code.  This way your local user always owns the content.