# Exercise 1: Exploring Images and Containers

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

### 1.03 Start a Container
Running containers from images is very simple.  Open two terminals for this section.

In Terminal #1, do:
```
docker run --rm -ti ubuntu:22.04
```

This creates the ubuntu container.  `-i` or `--interactive` keeps STDIN open and `-t` or `--tty` allocates a psuedo TTY terminal interface with the container.  `--rm` directs the daemon to remove the container when it is stopped.

Now, in Terminal #2 look at the running containers.
```
docker ps
```
This command shows the running containers.  Note that the containers have and id and a name -- both of these can be used to identify containers in commands.  If you dont't set a name when the container starts, a random one is applied.  `docker ps -a` will show stopped containers as well.

In Terminal # 2, open another bash session in the running container
```
docker exec -ti <container id/name> bash
```

The `exec` command executes a command in the container.  Next, pass either the container id or its name (you can press tab to autocomplete).    Last, provide a command to execute: here we execute `bash` to open a shell.

In Terminal #2, do
```
exit
```


### 1.04 Explore the container

Get your bearings in the running container.  Take a look at the active user, where you are in the directory structure and where your home directory is:
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
The container is no longer in the list of running containers or stopped ones, because when we created it we passed the parameter `--rm` to remove the container when it was stopped.

### 1.05 Create a volume and other configurations

Next, take a look at the many optional configurations you can set with run:
```
docker run --help
```

We will start a new container, add a volume and set a default working directory:

```
mkdir mydir
docker run -d -ti -w /root -v ./mydir:/root/mydir ubuntu:22.04
```

`-d` instructs the daemon to start the container in a detached state, so it is running, but you are not connected to it.
`-ti` enables a pseudo-TTY and keeps stdin open.
`-w` sets a working directory to open, in this case `/root`.
`-v` binds the directory on the host at `./mydir` to the container at `/root/mydir`


Open a shell session inside the container and see how it changed
```
docker exec -ti <container_name> bash
```
Notice what directory you are in, and that the folder is now available inside the container.  Next, create a file in `mydir` and then exit.
```
cd mydir && touch testfile
exit
```

Now on the host navigate to `mydir` and list the ownership details
```
cd mydir && ls -l
```
You'll see that the file is owned by root.  You can avoid this most simply by doing file creation and editing from the host, rather than the container.  Sometimes though, you can't avoid creating files from the container.  We will discuss how to handle this important feature.

Finally, remove the container with
```
docker container stop && docker container rm <container id/name>
```