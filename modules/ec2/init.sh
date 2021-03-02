#!/bin/bash

sudo apt -y update
sudo apt -y upgrade

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
   Web One
   </title>
 </head>
 
 <body>
   Website One.
 </body>
 </html>" > ~/site-content/index.html

docker run -v ~/site-content:/usr/share/nginx/html --name myweb -p 80:80 -d nginx