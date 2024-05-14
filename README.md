# LAMP Installer script on Ubuntu 18, 20, 22 LTS

Here’s an enhanced version of the LAMP stack installation script that includes the automatic configuration of a sample website and a MySQL database. The script will:

1. Update the package list.
2. Install Apache.
3. Install MySQL.
4. Install PHP.
5. Configure Apache to use PHP.
6. Set up a sample website.
7. Create a MySQL database and user.
8. Restart Apache to apply the changes.
   
You can save this script as lamp_installer-script.sh and run it with sudo bash lamp_installer-script.sh
------------------------------------------------
# Running the Script

1. Save or clone the script to a file, lamp_installer-script.sh
2. Make the script executable:
chmod +x lamp_installer-script.sh
3. Run the script with sudo:
sudo ./lamp_installer-script.sh
