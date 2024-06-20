#!/bin/bash
 
# Install necessary packages (assuming Amazon Linux 2)
sudo yum update -y
sudo yum install -y httpd
 
# Start Apache web server
sudo systemctl start httpd
sudo systemctl enable httpd
 
# Create index.html file with content
echo "<!DOCTYPE html>" | sudo tee /var/www/html/index.html
echo "<html><head><title>Welcome</title></head><body>" | sudo tee -a /var/www/html/index.html
echo "<h1>Welcome to My world</h1>" | sudo tee -a /var/www/html/index.html
echo "</body></html>" | sudo tee -a /var/www/html/index.html
 
# Adjust file permissions
sudo chmod 644 /var/www/html/index.html
sudo chown root:root /var/www/html/index.html
 
# Restart Apache to apply changes
sudo systemctl restart httpd