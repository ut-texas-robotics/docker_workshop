# Docker for Robotics Workshop

This repo contains exercises and supporting documentation for the workshop last held on September 27, 2024.  Participants learned how to use Docker to run ROS on robot hardware, regardless of the required Ubuntu OS and ROS versions.

## Using the Documentation

If you are new to Docker, take a look at the workshop resources before moving on to the sections below.  Read through the PDF presentation fully before watching the workshop zoom recording.

- [presentation.pdf](./presentation.pdf)
- [exercise files](./exercises)
- [zoom recording](https://utexas.box.com/s/42mzc45268nz9som2ic2anw6ie5jlqzb) for NRG students

## Install Docker Software

- [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Install NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) if you are using NVIDIA drivers
- [Post-Installation Steps](https://docs.docker.com/engine/install/linux-postinstall/)
- [Plugin: docker sbom](https://github.com/docker/sbom-cli-plugin)

Follow the instructions at the links above to install Docker Engine for ubuntu, the NVIDIA Container Toolkit if you are using an nvidia graphics card and drivers, and the docker sbom plugin.  Use the apt repository installation methods.  Be sure to follow the post-installation steps if you want to run docker without `sudo`.

Be careful not to install Docker Desktop -- this workshop does not use it.  Docker interacts with the Linux kernel, and this workshop assumed working on computers with a native linux OS only.  Docker for Windows and Mac both run Docker inside of a VM, and handling that is outside of the scope of this lesson plan.

## Use the Development Environment

Follow the instructions at [docs/use_the_dev_env](./docs/use_the_dev_env.md) to customize and use the Docker container code here as a development environment for working on your own robotics code.
