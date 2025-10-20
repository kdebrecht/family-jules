#!/usr/bin/env bash

# 7. Install and Configure Nginx
echo "Installing and configuring Nginx..."
sudo apt-get install -y nginx

# Create Nginx server block configuration
cat > /etc/nginx/sites-available/laravel <<EOF
server {
    listen 80;
    server_name _;
    root ${PROJECT_DIR}/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php${PHP_VERSION}-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        fastcgi_index index.php;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF

# Enable the site and restart Nginx
ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
unlink /etc/nginx/sites-enabled/default # Disable default Nginx page
systemctl restart nginx
systemctl restart php${PHP_VERSION}-fpm
