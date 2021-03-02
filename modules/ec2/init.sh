#!/bin/bash

sudo apt -y update
sudo apt -y upgrade

sudo apt -y install docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu
sudo newgrp docker
docker --version

docker run --name mynginx1 -p 80:80 -d nginx