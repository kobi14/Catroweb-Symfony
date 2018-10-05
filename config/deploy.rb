# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/share"

# Default value for :format is :airbrussh.
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Uncomment the following to require manually verifying the host key before first deploy.
set :ssh_options, verify_host_key: :secure

########################
# Setup project
########################
set :application, "PocketCode_Share"
# set :repo_url, "git@github.com:Catrobat/Catroweb-Symfony.git"
set :repo_url, "https://github.com/Catrobat/Catroweb-Symfony.git"

#########################
# Setup Capistrano
#########################
set :log_level, :info
set :ssh_options, {
  forward_agent: true
}
set :keep_releases, 5



# Symfony console commands will use this environment for execution
# set :symfony_env,  "prod"

# Set this to 2 for the old directory structure
set :symfony_directory_structure, 3

# Set this to 4 if using the older SensioDistributionBundle
set :sensio_distribution_version, 5

# symfony-standard edition directories
set :app_path, "app"
set :web_path, "web"
set :var_path, "var"
set :bin_path, "bin"

# The next 3 settings are lazily evaluated from the above values, so take care
# when modifying them
set :app_config_path, "app/config"
set :log_path, "var/logs"
set :cache_path, "var/cache"

set :symfony_console_path, "bin/console"
set :symfony_console_flags, "--no-debug"

# Remove app_dev.php during deployment, other files in web/ can be specified here
set :controllers_to_clear, ["app_*.php", "config.php", "apple-touch-icon.png", "*.scss"]

# asset management
set :assets_install_path, "web"
set :assets_install_flags,  '--symlink'

# Share files/directories between releases
set :linked_files, ["app/config/parameters.yml"]
set :linked_dirs, ["app/logs", "web/resources/apk", "web/resources/extract",
"web/resources/featured", "web/resources/mediapackage", "web/resources/programs",
"web/resources/screenshots", "web/resources/teachers", "web/resources/templates/screenshots",
"web/resources/templates/thumbnmails","web/resources/thumbnails", "web/resources/tmp/uploads/thumb",
"vendor", "backups", "Resources/Snapshots"]

# Set correct permissions between releases, this is turned off by default
# set :file_permissions_paths, ["var"]


set :file_permissions_roles, :all
set :file_permissions_paths, ["app/logs", "web/resources/featured", "backups", "app/cache", "app/cache/dev"]
set :file_permissions_users, ["www-data"]
set :file_permissions_groups, ["www-data"]
set :file_permissions_chmod_mode, "0777"
set :permission_method, false

# Role filtering
set :symfony_roles, :all

#######################################
# Linked files and directories (symlinks)
#######################################
#set :linked_dirs, [fetch(:log_path), fetch(:web_path) + "/uploads"]
# set :file_permissions_paths, [fetch(:log_path), fetch(:cache_path)]
set :composer_install_flags, '--no-interaction --optimize-autoloader'

# default_run_options[:pty]
namespace :deploy do
  before 'deploy:updated', 'deploy:set_permissions:chown'
  after 'deploy:updated', 'composer:install_executable'
  after 'deploy:updated' do  execute! :sudo, "sudo chown -R www-data:www-data current/#{fetch(:cache_path)}" end
#   after 'deploy:updated', "sudo chown -R www-data:www-data current/#{fetch(:cache_path)}"

#   after :updated, do
#     run 'composer:install_executable'
#     run "sudo chown -R www-data:www-data #{latest_release}/#{cache_path}"
#     run "sudo chown -R www-data:www-data #{latest_release}/#{log_path}"
#     run "sudo chmod -R 777 #{latest_release}/#{cache_path}"
#   end
end



