# Exercise 2: Creating Images with Dockerfiles

Open this repo in Visual Studio Code, or a similar editor.  Its best to have an explorer view to see all the files contained.

Open `Docker/Dockerfile` and let's create a file together.

## Images are Composed of Layers

Each Dockerfile instruction, roughly speaking, creates a layer in the image.  These layers are points of refernce for the image history, for the build process and for image execution later.  When you change an instruction, Docker looks in the layer cache and finds the most recent layer before the change, and uses that as a starting point for rebuilding the image.

## Dockerfiles for Development

**Q:** What goes in my Dockerfile?

**A:**

When writing an image for development environments, it can be helpful to consider the function of an image as building that environment, and not packaging an entire application or configuring all parameters.  You can use other tools for configuration like docker compose, environment files, bash scripts and/or makefiles.

Many docker users write images for containing entire applications and setting configs, and this is not wrong.  It just depends on how the container is intended to be used.

## Docker Build Context

The build context is usually the folder containing the `Dockerfile`.  From here, you can run `docker build` and `docker compose` commands.

## Base Images

Most Dockerfiles start with a base image and build on top of that.  [Docker Hub](https://hub.docker.com/) is a public repository that hosts many official images, including those from Ubuntu and ROS.

Search Docker Hub for images to get the image name and the tag matching your desired version.  Find many details on the image page like usage and links to the Dockerfiles used to create those images.

## Common Dockerfile commands

| Instruction  | Description  | Usage |
|--------------|--------------|-----------|
| `FROM`       | - Pull a base image from a registry, Docker Hub, or your own collection  | Examples images are `ros`, `conda`, `ubuntu:22.04`, etc. <br> `FROM <image:tag>` |
| `RUN`        | - Each of these commands is a layer <br> - `RUN` is often used to execute multiple bash commands strung together with `&&` <br>  | `RUN <command>` <br>`RUN ["executable", "param1", "param2"]`  |
| `ENV`        | - These are environment variables you need in the build process, not necessarily in your config |   |
| `SHELL`      | - Set the default shell to use - If left undefined, it's `/bin/sh` |  `SHELL ["/bin/bash", "-c"]` |
| `COPY`       | - Copy a file/folder into the container, such as an entrypoint script |  `COPY <source> <destination>` |
| `CMD`        | - `CMD` is not the same as `RUN` <br> - This is the command that is executed when you start a container.  <br> - It does not contribute to building your image; it only provides a directive for what should be executed when you start a container from the image | `CMD ["executable","param1","param2"]` <br>`CMD <command>`, <br>`CMD ["param1", "param2"]`  |
| `ENTRYPOINT` | - This is a script that runs when you start a container, rather than a simple command  <br> - It is copied into the image when you build it  <br> - The benefit is that you can dynamically make changes to the container using the script  <br> - The challenge is that you may need to pass parameters to it |  `ENTRYPOINT entrypoint.sh` |

See a full list in the [Docker Docs](https://docs.docker.com/engine/reference/builder/)

## Build and Run an Image

When you're finished editing the Dockerfile, build the image with
```
docker build -t rosd_i:file_only .
```
`-t` names and tags the image with the provided info and `.` indicates the build context.

Run a container from the image
```
docker run -d -ti -w /root -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=${DISPLAY} -e QT_X11_NO_MITSHM=1 --security-opt apparmor:unconfined rosd_i:file_only
```
Test ROS and bring up RViz with
```
rosrun rviz rviz
```
