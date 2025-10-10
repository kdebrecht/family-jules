#!/usr/bin/env bash

#####
#
#   Setup permissions to allow logs to be written and have git ignore the changes
#
###

sudo apt-get update && sudo apt-get install -y acl

# Tell git to ignore file access (need to be able to write to logs)
git config core.fileMode false

# Set permissions for the folder and its current contents
sudo setfacl -R -m u::rwx,g::rwx,o::rwx $PWD

# Set default permissions for any new files/folders created inside
sudo setfacl -d -m u::rwx,g::rwx,o::rwx $PWD

