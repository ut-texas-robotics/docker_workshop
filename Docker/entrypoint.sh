#!/bin/bash

set -e

echo "in the entrypoint script"
while getopts :u:n: flag; do
    case "${flag}" in
        u)
          userid=${OPTARG}
          ;;
        n)
          uname=${OPTARG}
          ;;
    esac
done

export uid=${userid%"${userid#????}"}

# check if the user already exists
if id "$uname" >/dev/null 2>&1; then
  echo "user $uname already exists"
else
  # create the host user in the container
  echo "user $uname does not exist, creating..."
  useradd -u $uid -s /bin/bash -G dialout $uname
fi

# set the user as the owner of the root directory
chown -R $userid /root
# allow users to edit the root directory
chmod 770 /root

if [ -d "/home/$uname" ]; then
  echo "home directory already exists for $uname"
else
  mkdir /home/$uname
  cp /root/.bashrc /home/$uname/.bashrc 
  cp /root/.profile /home/$uname/.profile
  # create a symlink to the projects volume
  cd /home/$uname && ln -s /root/projects projects
  chown -R $uname /home/$uname
fi

# give the host user sudo permissions
echo "$uname ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$uname && \
    chmod 0440 /etc/sudoers.d/$uname

source /opt/ros/noetic/setup.bash

# execute a command in the container
roscore