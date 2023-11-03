# Docker for Robotics Workshop

This repo contains exercises and supporting documentation for the workshop held on November 3, 2023.

## Install Docker Software

- [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Install NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- [Post-Installation Steps](https://docs.docker.com/engine/install/linux-postinstall/)
- [Plugin: docker sbom](https://github.com/docker/sbom-cli-plugin)

Follow the instructions at the links above to install Docker Engine for ubuntu, the NVIDIA Container Toolkit if you are using an nvidia graphics card and drivers, and the docker sbom plugin.  Use the apt repository installation methods.  Be sure to follow the post-installation steps if you want to run docker without `sudo`.

Be careful not to install Docker Desktop -- this workshop does not use it.  Docker interacts with the Linux kernel, and for the purposes of this workshop we will be working on computers with a native linux OS only.  Docker for Windows and Mac both run Docker inside of a VM, and handling that is outside of the scope of this lesson plan.
