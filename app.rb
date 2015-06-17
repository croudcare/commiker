module Commiker

  class Web < ::Sinatra::Base

    UseCases = Commiker::V0::UseCases
    Serializers = Commiker::V0::Serializers

    helpers  ::Sinatra::JSON
    register ::Sinatra::Partial
    register Commiker::Sinatra::CurrentUser
    register Commiker::Sinatra::ErrorHandling
    register ::Sinatra::ActiveRecordExtension

    set :environments, %w{development staging production}

    set :root,                    File.dirname(__FILE__)
    set :views,                   Proc.new { File.join(root, 'app/web/views') }
    set :public_folder,           Proc.new { File.join(root, 'public') }
    set :partial_template_engine, :erb

    enable :logging, :partial_underscores

    use Rack::Parser, :content_types => {
      'application/json' => Proc.new { |body| ::MultiJson.decode body },
      'application/json;charset=UTF-8' => Proc.new { |body| ::MultiJson.decode body }
    }

    configure :development do
      enable :dump_errors, :raise_errors
      use ::BetterErrors::Middleware
    end

    configure :staging, :production do
      set :raise_errors, true
      set :show_exceptions, false
      set :dump_errors, false

      file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
      file.sync = true
      use Rack::CommonLogger, file
    end

  end

end
