#!/bin/bash

# Install Node.js and NPM
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Nginx
sudo apt-get install -y nginx

# Create Nginx configuration files
sudo tee /etc/nginx/sites-available/web.example.com >/dev/null <<EOF
server {
    listen 80;
    server_name web.example.com;

    location / {
        proxy_pass http://localhost:3000;  # Assuming web app runs on port 3000
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo tee /etc/nginx/sites-available/api.example.com >/dev/null <<EOF
server {
    listen 80;
    server_name api.example.com;

    location / {
        proxy_pass http://localhost:5000;  # Assuming API runs on port 5000
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable the Nginx configuration files
sudo ln -s /etc/nginx/sites-available/web.nodeweb.com /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/pi.nodejs1.com /etc/nginx/sites-enabled/

# Install Certbot and provision SSL certificates
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d web.nodeweb.com -d api.nodejs1.com --non-interactive --agree-tos --email your-kisho436@gmail.com
