FROM ros:noetic-ros-base-focal

SHELL ["/bin/bash", "-c"]

# set the ros version
ENV ROS_DISTRO noetic

# install some useful packages and upgrade existing ones
RUN apt update && apt upgrade -y \
    && apt install -y \
    apt-utils \
    git \
    curl \
    nano \
    vim \
    tmux \
    x11-apps \
    python3-pip \
    python3-catkin-tools \
    python-is-python3 \
    libqt5websockets5-dev \
    qt5-default

# install ros packages
# see ../docs/installing_ros_packages.md for alternatives
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    ros-${ROS_DISTRO}-desktop-full \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep update

# switch to home dir
WORKDIR /root

# setup a package from github
RUN git clone https://github.com/ut-amrl/amrl_msgs.git
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && cd amrl_msgs \
    && export ROS_PACKAGE_PATH=`pwd`:$ROS_PACKAGE_PATH \
    && make -j

# setup .bashrc
SHELL ["/bin/bash", "-l", "-c"]
RUN echo -e "\
    source /opt/ros/${ROS_DISTRO}/setup.bash\n\
    export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:~/amrl_msgs" >> ~/.bashrc \
    && echo -e "\
    source /opt/ros/${ROS_DISTRO}/setup.bash\n\
    export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:~/amrl_msgs" >> ~/.profile

# CMD ["roscore"]
# copy the entrypoint into the image
COPY ./entrypoint.sh /entrypoint.sh
# run this script on startup
ENTRYPOINT /entrypoint.sh