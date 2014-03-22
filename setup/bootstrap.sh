#!/usr/bin/env bash

echo "--- Installing mongodb ---"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/10gen.list
sudo apt-get update
sudo apt-get install mongodb-10gen

echo "--- Installing node.js ---"
sudo apt-get update
sudo apt-get install -y python-software-properties python g++ make
sudo add-apt-repository  -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs

echo "--- Setting up database ---"
cd /vagrant
#sleep 20

echo "--- Starting app ---"
sudo npm install forever -g
#NODE_ENV=test  node app.js & > /dev/null 2>&1
#sleep 20
