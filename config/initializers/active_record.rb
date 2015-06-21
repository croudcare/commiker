# establish db connection
if ENV['RACK_ENV'] == 'production'
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  ActiveRecord::Base.establish_connection(YAML::load_file('./config/database.yml')[ENV["RACK_ENV"]])
end
