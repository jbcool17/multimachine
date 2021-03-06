DEPLOY_USER=$1
APP_NAME=$2
# Setting up a user account : As sudo user - 'root/vagrant'

# Add user account
sudo adduser $DEPLOY_USER
sudo passwd $DEPLOY_USER

# Setup initial SSH key
sudo mkdir -p ~$DEPLOY_USER/.ssh
sudo sh -c "cat $HOME/.ssh/authorized_keys >> ~$DEPLOY_USER/.ssh/authorized_keys"
sudo chown -R $DEPLOY_USER: ~$DEPLOY_USER/.ssh
sudo chmod 700 ~$DEPLOY_USER/.ssh
sudo sh -c "chmod 600 ~$DEPLOY_USER/.ssh/*"

# Setting up a site directory structure
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
