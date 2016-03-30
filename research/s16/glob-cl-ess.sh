#!/bin/bash

sudo apt-get update
sudo apt-get install vim -y
sudo apt-get install apache2 -y
sudo apt-get install screen -y

wget http://toolkit.globus.org/ftppub/gt6/installers/repo/globus-toolkit-repo_latest_all.deb	
sudo dpkg -i globus-toolkit-repo_latest_all.deb
sudo apt-get update
sudo apt-get install globus-data-management-client
