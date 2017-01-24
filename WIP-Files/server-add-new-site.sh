DEPLOY_USER=$1
APP_NAME=$2

# Setting up a site directory structure : As sudo user - 'root/vagrant'
sudo mkdir -p /var/www/$APP_NAME
sudo chown $DEPLOY_USER: /var/www/$APP_NAME

# Create Config Files - Login as Deploy User # Permissions
sudo -u deploy -H bash -l
mkdir -p /var/www/$APP_NAME/shared/config
touch /var/www/$APP_NAME/shared/config/database.yml
touch /var/www/$APP_NAME/shared/config/secrets.yml
chmod 600 /var/www/$APP_NAME/shared/config/secrets.yml /var/www/$APP_NAME/shared/config/database.yml

echo ""
echo "Script has run."
