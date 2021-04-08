#!/bin/bash

sleep 30
sudo yum update -y

# install nginx
sudo amazon-linux-extras install nginx1 -y

# Move the index.html file into place
sudo mv /tmp/index.html /usr/share/nginx/html/index.html

# Start nginx
sudo systemctl enable nginx
sudo systemctl start nginx