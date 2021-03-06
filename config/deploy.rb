# config valid only for current version of Capistrano
lock '3.6.0'

set :application, 'AwsTest'
set :repo_url, 'https://github.com/ChitSuClover/AwsTest.git'

# Default branch is :master
set :branch, ENV['BRANCH'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/AwsTest'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{.env config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
 set :keep_releases, 5
 set :rbenv_ruby, '2.6.5'
 set :rbenv_type, :system
 set :log_level, :info
 namespace :deploy do
   desc 'Restart application'
   task :restart do
     invoke 'unicorn:restart'
   end
   desc 'Create database'
   task :db_create do
     on roles(:db) do |host|
       with rails_env: fetch(:rails_env) do
         within current_path do
           execute :bundle, :exec, :rake, 'db:create'
         end
       end
     end
   end
   desc 'Run seed'
   task :seed do
     on roles(:app) do
       with rails_env: fetch(:rails_env) do
         within current_path do
           execute :bundle, :exec, :rake, 'db:seed'
         end
       end
     end
   end
   after :publishing, :restart
   after :restart, :clear_cache do
     on roles(:web), in: :groups, limit: 3, wait: 10 do
     end
   end
 end
