#!/bin/bash

# Variables
DB_NAME="sample_db"
DB_USER="sample_user"
DB_PASS="sample_password"
SITE_DIR="/var/www/html"
SITE_NAME="sample_site"
APACHE_CONF="/etc/apache2/sites-available/${SITE_NAME}.conf"

# Update package list
echo "Updating package list..."
sudo apt update -y

# Install Apache
echo "Installing Apache..."
sudo apt install apache2 -y

# Enable Apache to run on startup
sudo systemctl enable apache2

# Start Apache service
sudo systemctl start apache2

# Install MySQL
echo "Installing MySQL..."
sudo apt install mysql-server -y

# Secure MySQL installation (automated)
echo "Securing MySQL installation..."
sudo mysql -e "UPDATE mysql.user SET authentication_string = PASSWORD('${DB_PASS}') WHERE User = 'root';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Start MySQL service
sudo systemctl start mysql

# Install PHP
echo "Installing PHP..."
sudo apt install php libapache2-mod-php php-mysql -y

# Create MySQL database and user
echo "Creating MySQL database and user..."
sudo mysql -e "CREATE DATABASE ${DB_NAME};"
sudo mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Create a sample PHP website
echo "Setting up sample website..."
echo "<?php phpinfo(); ?>" | sudo tee ${SITE_DIR}/index.php

# Create Apache configuration for the site
echo "Creating Apache configuration for the site..."
sudo bash -c "cat > ${APACHE_CONF}" <<EOL
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot ${SITE_DIR}
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    <Directory ${SITE_DIR}>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOL

# Enable the new site and disable the default site
sudo a2dissite 000-default.conf
sudo a2ensite ${SITE_NAME}.conf

# Restart Apache to apply changes
echo "Restarting Apache..."
sudo systemctl restart apache2

# Provide status of services
echo "Checking Apache status..."
sudo systemctl status apache2

echo "Checking MySQL status..."
sudo systemctl status mysql

# Provide feedback
echo "LAMP stack installation and configuration completed."
echo "Sample website available at http://your_server_ip/"
echo "MySQL database '${DB_NAME}' with user '${DB_USER}' created."
echo "PHP info page created at http://your_server_ip/index.php."
echo "Enjoy your hosting enviroment, Have a nice day!"

# End of script
