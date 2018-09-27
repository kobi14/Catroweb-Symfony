# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "PocketCode"
#set :repo_url, "git@example.com:me/my_repo.git"

set :deploy_via, :rsync_with_remote_cache

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/share.catrob.at"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
set :local_user, -> { 'deploy' }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# Symfony console commands will use this environment for execution
set :symfony_env,  "prod"

# Set this to 2 for the old directory structure
set :symfony_directory_structure, 2

# Set this to 4 if using the older SensioDistributionBundle
set :sensio_distribution_version, 5

# symfony-standard edition directories
set :app_path, "app"
set :web_path, "web"
set :bin_path, "bin"

# The next 3 settings are lazily evaluated from the above values, so take care
# when modifying them

set :app_config_path, "app/config"
set :log_path, "app/logs"
set :cache_path, "app/cache"

set :symfony_console_path, "app/console"
set :symfony_console_flags, "--no-debug"

# Remove app_dev.php during deployment, other files in web/ can be specified here
set :controllers_to_clear, ["app_*.php", "config.php", "ressources_test/*"]
set :controllers_to_clear, ["../src/Catrobat/AppBundle/Features/*"]

# asset management
set :assets_install_path, "web"
set :assets_install_flags,  '--symlink'

# Share files/directories between releases
set :linked_files, ["app/config/parameters.yml"]
set :linked_dirs, [app_path + "/logs", web_path + "/resources", "backups", "Resources/Snapshots"]

# Set correct permissions between releases, this is turned off by default
set :file_permissions_paths, ["app/cache", "app/logs", "backups", "web/resources/featured", "web/resources/extract", 
	"web/resources/programs", "web/resources/screenshots", "web/resources/thumbnails", "web/resources/apk", 
	"web/resources/mediapackage", "Resources/Snapshots"]
set :permission_method, false
set :file_permissions_users, ["www-data"]

# Role filtering
set :symfony_roles, :all
