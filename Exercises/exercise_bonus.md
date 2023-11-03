# Creating Bash Utilities for Docker

There are many benefits to creating scripts for running docker commands.  First, it allows you to streamline running containers, and second, it allows you to dynamically create the host user in the container.

## Incorporating Bash Functions

The Docker context is a good place to put bash funtions.  Create a file called `bash_utils` in the Docker directory.
```
touch Docker/bash_utils
```

Edit the file to include several functions

### Start
```
rosd-start(){
    #add xhost permissions for docker to use display
    xhost +si:localuser:root
    echo "added docker xhost permissions"
    export UID_GID=$(id -u):$(id -g)
    export UNAME=$(whoami)
    echo "gathering host user info... $UNAME $UID_GID"
    docker compose -f $ROSD_DIRECTORY/Docker/docker-compose.yaml up -d
}
```
This start function adds X11 permissions, gathers the user id and name, finds the Docker context and then starts the container in detached mode.  The user's info is passed to the entrypoint to create the host user in the container.

### Stop and Shell
```
rosd-stop(){
    # stop the container and remove it
    docker compose -f $ROSD_DIRECTORY/Docker/docker-compose.yaml down
}

rosd-shell() {
    # open a shell in the container
    docker exec -ti -u $USER rosd_c bash -l
}
```
The stop function stops and removes the container from within the build context, and the shell function opens a shell as the host user inside the container.  This requires that the host user was setup in the entrypoint.


### Build
```
rosd-build() {
    # if the container is running, stop it
    if [ "$(docker ps -q -f name=rosd_c)" ]; then
        echo "stopping container rosd_c..."
        docker compose -f $ROSD_DIRECTORY/Docker/docker-compose.yaml down
    fi
    # build the container from the docker-compose file
    docker compose -f $ROSD_DIRECTORY/Docker/docker-compose.yaml build
}
```
The build function does some housekeeping to stop any running container and then build.  It uses the `$ROSD_DIRECTORY` environment variable to find the build context.

### Logs and Setting Environment Variable
```
rosd-dir() {
    # Set the directory of the docker_workshop repo on the host
	# Usage: rosd-dir path_to_rosd_docker_dir
	# Alternatively, add it to your .bashrc for convenience
    export ROSD_DIRECTORY=$1
}

rosd-log() {
    # view the logs of the picogk container
    docker logs rosd_c
}
```
The dir function is a shortcut for creating the `ROSD_DIRECTORY` environment variable.  The log function shows the container logs.

## Setup Bash Utilities

Set the `ROSD_DIRECTORY` environment variable and source the `bash_utils` file in your `~/.bashrc`
```
cd <repo top level>
echo "export ROSD_DIRECTORY=$(pwd) >> ~/.bashrc
echo "source $ROSD_DIRECTORY/Docker/bash_utils" >> ~/.bashrc
```

## Alternatives

You could add similar commands to a Makefile.