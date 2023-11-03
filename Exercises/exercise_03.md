# Exercise 3: Build and Configure with Docker Compose

Open this repo in Visual Studio Code, or a similar editor.  Its best to have an explorer view to see all the files contained.

Open `Docker/docker-compose.yaml` and let's add configurations together.

## What is Docker Compose

Docker Compose is a tool for created for defining and running multi-container applications, but it is very useful for configuring even single containers for robots. It allows you to describe your application's services, networks, devices, and volumes in a single `.yaml` file, and then use a short command (`docker-compose up`) to start and run all the services defined in that file.

## Core Concepts

Compose is for both building and running.  The `docker-compose.yaml` goes in the same directory as your `Dockerfile`.

**Important Components:**

- Services
- Context
- Image
- Container
- Environment Variables
- Volumes
- Networks
- Devices
- Command
- Entrypoint

More information is available in the [Docker Compose Docs](https://docs.docker.com/compose/)

## Entrypoint Scripts

In Dockerfiles and in Docker Compose, you can provide an entrypoint to the container.  This is a script that runs when the container starts.  It is a good place to handle things like dynamically creating users in the container, changing file permissions, or setting up other parameters that must be set at runtime rather than in a Dockerfile.

## Environment Files

Environment files are a convenient way to set environment variables that are specific to a robot.  Perhaps your container will be run by many types of robots.  You can set an environment file to create variables for each one when the container starts.

Create a file called `robot.env` and add some variables to it
```
export MY_ENV_VAR=/something/special
```
Add the path to the `env_file:` parameter in `docker-compose.yaml`.

## Build and Run

Again, run these commands from the direcory containing your Dockerfile and docker-compose.yaml.

To build an image, do simply
```
docker compose build
```
Then, to start the services described in the file, do
```
docker compose up
```
Afterward, to stop the running services and remove containers (ie delete them), do
```
docker compose down
```

## Practical Considerations

You may have a single container that works on several different robots.  In that case, it can be useful to have different Compose files or Environment files for each one.

When working on real robots versus simulation, you can use the `devices` parameter in `docker-compose.yaml` to toggle connecting or disregarding hardware.