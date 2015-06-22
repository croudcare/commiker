require "bundler/capistrano"
require 'capistrano/ext/multistage'
require 'rvm/capistrano'

set :stages, %w(production staging)

set :deploy_location do
  deploy_to = Capistrano::CLI.ui.ask 'Deploy to (p)roduction:'
  case deploy_to.split.first
    when 'p' then :production
    else :staging
  end
end

set :rvm_type, :system
set :rvm_ruby_string, '2.1.5'

set :default_stage, deploy_location
set :keep_releases, 4
set :normalize_asset_timestamps, false
set :config_files, %w(config.yml database.yml)

set :application, 'commiker'
set :deploy_via, :remote_cache
set :repository, 'git@github.com:croudcare/commiker.git'

default_run_options[:pty] = true
set :use_sudo, false
set :port, 22

namespace :deploy do
    # Restart passenger on deploy
    desc "Restarting mod_rails with restart.txt"
    task :restart, :roles => :app, :except => { :no_release => true } do
        run "touch #{release_path}/tmp/restart.txt"
    end

    [:start, :stop].each do |t|
        desc "#{t} task is a no-op with mod_rails"
        task t, :roles => :app do ; end
    end

  desc "links configuration files"
  task :link_config_files, :roles => :app do
    config_files.each do |file|
      run "ln -sf #{shared_path}/config/#{file} #{release_path}/config/#{file}"
    end
  end

  task :migrations do
    run "cd #{current_path} && RACK_ENV=#{rails_env} bundle exec rake db:migrate"
  end
end

before "deploy:finalize_update", "deploy:link_config_files"
after "deploy:restart", "deploy:cleanup"
before "deploy:migrations", "deploy"

