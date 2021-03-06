puts "\e[0;35m =======================================================\e[0m\n"
puts "\e[0;35m              DEPLOYING TO PRODUCTION\e[0m\n"
puts "\e[0;35m =======================================================\e[0m\n"

set :rails_env, 'production'
set :domain, 'prd_commiker'
set :runner, 'rails'

server domain, :app, :web

role :db, domain, :primary => true

ssh_options[:forward_agent] = true
ssh_options[:user] = runner

set :branch, "master"
set :deploy_to, "/var/www/rails/#{application}"
