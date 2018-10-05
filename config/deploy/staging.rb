#######################
# Setup Server
########################
server "cat-share-exp.ist.tugraz.at", user: "unpriv", roles: %w{web}
set :deploy_to, "/var/www/share/"


#########################
# Capistrano Symfony
#########################
set :symfony_env,  "dev"
set :linked_files, ["app/config/parameters.yml", "app/config/parameters_dev.yml"]
set :controllers_to_clear, ["config.php", "apple-touch-icon.png", "*.scss"]

#########################
# Setup Git
#########################
set :branch, "php7Iwillsaveyou"


