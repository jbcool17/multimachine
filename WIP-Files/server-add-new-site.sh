DEPLOY_USER=$1

# Setting up a user account
# Add user account
# sudo adduser $DEPLOY_USER &&

# Setup initial SSH key
# sudo mkdir -p ~$DEPLOY_USER/.ssh &&
# sudo sh -c "cat $HOME/.ssh/authorized_keys >> ~$DEPLOY_USER/.ssh/authorized_keys" && \
# sudo chown -R $DEPLOY_USER: ~$DEPLOY_USER/.ssh &&
# sudo chmod 700 ~$DEPLOY_USER/.ssh &&
# sudo sh -c "chmod 600 ~$DEPLOY_USER/.ssh/*"

# Setting up a basic directory structure
APP_NAME=$2
sudo mkdir -p /var/www/$APP_NAME/shared
sudo chown $DEPLOY_USER: /var/www/$APP_NAME /var/www/$APP_NAME/shared

# Create Config Files
sudo mkdir -p /var/www/$APP_NAME/shared/config
touch /var/www/$APP_NAME/shared/config/database.yml &&
touch /var/www/$APP_NAME/shared/config/secrets.yml

# Permissions
sudo chown -R $DEPLOY_USER: /var/www/$APP_NAME/shared/config/secrets.yml
sudo chown -R $DEPLOY_USER: /var/www/$APP_NAME/shared/config/database.yml

sudo chown myappuser: /var/www/myapp
sudo chown -R 600:$DEPLOY_USER /var/www/$APP_NAME/shared/config/database.yml
chmod 600 /var/www/$APP_NAME/shared/config/secrets.yml
chmod 600 /var/www/$APP_NAME/shared/config/database.yml


echo ""
echo "Script has run."
echo "Fill in those config files."
echo "database.yml / secrets.yml / nginx"


sudo mkdir -p ~deploy/.ssh &&
sudo sh -c "cat $HOME/.ssh/authorized_keys >> ~deploy/.ssh/authorized_keys" && \
sudo chown -R deploy: ~deploy/.ssh &&
sudo chmod 700 ~deploy/.ssh &&
sudo sh -c "chmod 600 ~deploy/.ssh/*"
