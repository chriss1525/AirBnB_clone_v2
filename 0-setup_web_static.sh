#!/usr/bin/env bash
# Script that sets up your web servers for the deployment of web_static
# install nginx if not already installed

install_nginx() {
  if ! which nginx > /dev/null 2>&1; then
    sudo apt-get -y update
    sudo apt-get install -y nginx
  fi
}

# create folders if not already created
create_folders() {
  if [ ! -d "/data/" ]; then
    sudo mkdir /data/
  fi
  if [ ! -d "/data/web_static/" ]; then
    sudo mkdir /data/web_static/
  fi
  if [ ! -d "/data/web_static/releases/" ]; then
    sudo mkdir /data/web_static/releases/
  fi
  if [ ! -d "/data/web_static/shared/" ]; then
    sudo mkdir /data/web_static/shared/
  fi
  if [ ! -d "/data/web_static/releases/test/" ]; then
    sudo mkdir /data/web_static/releases/test/
  fi
}

# create fake html file
create_fake_html() {
  if [ ! -f "/data/web_static/releases/test/index.html" ]; then
    sudo touch /data/web_static/releases/test/index.html
    sudo echo "Hello World" | sudo tee /data/web_static/releases/test/index.html
  fi
}

# create symbolic link
create_symbolic_link() {
  if [ -L "/data/web_static/current" ]; then
    sudo rm /data/web_static/current
  fi 
  sudo ln -s /data/web_static/releases/test/ /data/web_static/current
}

# give ownership of the /data/ folder to the ubuntu user AND group
give_ownership() {
  sudo chown -R ubuntu:ubuntu /data/
}

# update the Nginx configuration to serve the content of /data/web_static/current/ to hbnb_static
update_nginx_config() {
  # Use BEGIN and END comments to locate the section for insertion
  sudo sed -i '/# server/c\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default
}

# restart nginx
restart_nginx() {
  sudo service nginx restart
}

# run all functions
install_nginx
create_folders
create_fake_html
create_symbolic_link
give_ownership
update_nginx_config
restart_nginx

exit 0

