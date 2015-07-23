workers Integer(ENV.fetch('MAX_WORKERS', 0))
threads_count = Integer(ENV.fetch('MAX_THREADS', 1))
threads threads_count, threads_count

preload_app! unless ENV.fetch('PRELOAD_APP', "true") == "false"

rackup      DefaultRackup
port        ENV.fetch('PORT', 8080)
environment ENV.fetch('RACK_ENV', 'development')

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

