require "bundler/capistrano"
require 'capistrano/ext/multistage'

set :stages, %w(production staging training)

set :deploy_location do
  deploy_to = Capistrano::CLI.ui.ask 'Deploy to (p)roduction, (s)taging or (t)raining [s]: '
  case deploy_to.split.first
    when 'p' then :production
    when 's' then :staging
    when 't' then :training
    else :staging
  end
end

set :default_stage, deploy_location
set :keep_releases, 4
set :normalize_asset_timestamps, false
set :config_files, %w(config.yml database.yml)

set :application, "commiker"
set :deploy_via, :remote_cache
set :repository, "git@github.com:croudcare/commiker.git"

default_run_options[:pty] = true
set :use_sudo, false
set :port, 22

namespace :deploy do
    # Restart passenger on deploy
    desc "Restarting mod_rails with restart.txt"
    task :restart, :roles => :app, :except => { :no_release => true } do
        run "touch #{current_path}/tmp/restart.txt"
    end

    [:start, :stop].each do |t|
        desc "#{t} task is a no-op with mod_rails"
        task t, :roles => :app do ; end
    end

    desc "un-vault and copy config files"
    task :configs, roles => :app do
        run "mkdir -p #{shared_path}/config"
        run "mkdir -p #{shared_path}/config/initializers"

        run_locally "git clone git@github.com:croudcare/vault.git vault"
        config_files.each do |file|
            run_locally "cd vault && blackbox_edit_start #{deploy_location}/#{application}/#{file}"
            run_locally "scp vault/#{deploy_location}/#{application}/#{file} #{runner}@#{domain}:#{shared_path}/config/#{file}"
        end

        run_locally "rm -rf ./vault"
    end

    desc "links configuration files"
    task :link_config_files, :roles => :app do
        config_files.each do |file|
            run "ln -sf #{shared_path}/config/#{file} #{release_path}/config/#{file}"
        end
    end

    desc "run swagger docs task"
    task :build_swagger_docs do
        run "cd #{current_path} && RACK_ENV=#{rails_env} bundle exec rake swagger:docs"
    end
end

before "deploy:finalize_update", "deploy:link_config_files"
after "deploy:restart", "deploy:cleanup"
before "deploy:configs", "deploy:setup"
