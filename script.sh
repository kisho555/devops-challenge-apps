#!/bin/bash

# Clone the application repository
git clone https://github.com/kisho555/devops-challenge-apps.git /opt/app

# Build the application (assuming it's a Node.js application)
cd /opt/app/webapp
npm install

cd /opt/app/api
pip install -r requirements.txt

# Restart the application (assuming it runs via Docker containers)
sudo docker-compose -f /opt/app/docker-compose.yml down
sudo docker-compose -f /opt/app/docker-compose.yml up -d
