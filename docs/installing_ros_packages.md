# Installing ROS packages in a Dockerfile

There are a few methods you could take to install ROS packages with a Dockerfile.

## Install a ros metapackage

If you're dismayed that the official images from ROS are only `ros-<distro>-base`, you can install the entire `ros-<distro>-desktop-full` package.  This will make your image larger, but less prone to missing packages as you develop.

Alternatively, you can install smaller packages or metapackages:
```
RUN apt update && apt install -y \
    ros-${ROS_DISTRO}-robot \
    ros-${ROS_DISTRO}-navigation \
    ros-${ROS_DISTRO}-viz \
    ros-${ROS_DISTRO}-pointcloud-to-laserscan
```

## Install from source code dependencies

In this example, a `.rosinstall` file is used to pull several packages from git into a temporary workspace, using `wstool` or `vcstool`.  Then, the `rosdep install` command is used to find dependencies in the `src` folder.  Finally, the temporary workspace is removed, becuase the code will be added for development later in a volume.

```
RUN source /opt/ros/melodic/setup.bash &&\
    mkdir -p tmp_ws/src &&\
    cd tmp_ws &&\
    wstool init src https://raw.githubusercontent.com/utexas-bwi/bwi/master/rosinstall/melodic.rosinstall &&\
    rosdep install --from-paths src --ignore-src --rosdistro melodic -y &&\
    cd /root && rm -r tmp_ws
```

## Use the ADD or COPY commands

There are some idiosyncrasies with these commands - review the [docker docs](https://docs.docker.com/engine/reference/builder/#add) before using them.

Similarly, you can use the Dockerfile ADD command to add a git repo.  Note that this does not include the `.git` directory by default.  You can change the behavior with the `--keep-git-dir=true` flag.

```
WORKDIR /root
RUN mkdir -p tmp_ws/src
ADD https://github.com/labname/robot_package.git ~/tmp_ws/src/robot_package
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && cd tmp_ws \
    && rosdep install --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y &&\
    cd /root && rm -r tmp_ws
```

Or, you can copy a directory from your local system to the image filesystem, such as
```
COPY ./Source /root/tmp_ws/src
```
The above command copies a folder called `Source` that is in the build context to a directory in the image at `/root/tmp_ws/src`.  Note that it will remain a part of the image unless to remove it later in the Dockerfile.
