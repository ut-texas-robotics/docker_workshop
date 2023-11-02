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
  useradd -u $uid -s /bin/bash $uname
fi

# set the user as the owner of the projects directory
chown -R $userid /root
# allow users to edit the root directory
chmod 770 /root

# give the host user sudo permissions
echo "$uname ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$uname && \
    chmod 0440 /etc/sudoers.d/$uname

#execute the command passed to the docker run
exec /bin/bash