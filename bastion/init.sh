#!/bin/bash

sudo apt -y update
sudo apt -y upgrade

sudo cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys

sudo apt -y install awscli

sudo apt -y install curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt install terraform

sudo apt -y install docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu
sudo newgrp docker
docker --version
mkdir ~/site-content
touch ~/site-content/index.html
echo "<html>
 <head>
   <title>
   Bastion Host
   </title>
 </head>
 
 <body>
   Bastion Server.
 </body>
 </html>" > ~/site-content/index.html

docker run -v ~/site-content:/usr/share/nginx/html --name myweb -p 80:80 -d nginx