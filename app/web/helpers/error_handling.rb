module Commiker
  module Sinatra

    module ErrorHandling

      def halt_with_401_current_user_not_found
        halt 401
      end

      def self.registered(app)

        app.helpers ErrorHandling

        app.error ActiveRecord::RecordNotFound do
          halt 404
        end

      end

    end

  end
end
