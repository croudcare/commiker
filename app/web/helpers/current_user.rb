module Commiker
  module Sinatra
    module CurrentUser

      module Helpers

        def authorize
          halt_with_401_current_user_not_found if current_user.blank?
        end

        def declared_params(namespace = nil)
          _declared_params = params.merge({
            current_user: current_user,
            current_session_user: current_session_user
          })

          if namespace
            _declared_params = declared_with_resource_attributes(_declared_params, namespace)
          end

          _declared_params
        end

        def current_session_user
          return @current_session_user if !@current_session_user.blank?

          user_id = Float(session[:user_id]).to_i rescue -1

          @current_session_user ||= Commiker::V0::UseCases::Users::FindOne.perform(id: session[:user_id]).user rescue nil
        end

        def current_user
          return @current_user if !@current_user.blank?

          user_id = Float(token_data['user_id']).to_i rescue -1

          @current_user ||= Commiker::V0::UseCases::Users::FindOne.perform(id: token_data['user_id']).user rescue nil
        end

        def token_data
          return @token_data if !@token_data.blank?
          return {}          if request.env['HTTP_AUTHORIZATION'].blank?

          @token_data ||= JWT.decode(request.env['HTTP_AUTHORIZATION'].split('Bearer')[1].strip, Configs['AUTHENTICATION_SECRET'])[0]
        end

        def declared_with_resource_attributes(declared_params, namespace)
          resource_name = "#{namespace}".singularize

          mappings = {
            "#{resource_name}" =>
            "#{resource_name}_attributes"
          }

          declared_params.keys.each do |k|
            if mappings[k]
              attributes = declared_params.delete(k).to_hash
              declared_params[mappings[k]] = Hashie::Mash.new(attributes)
            end
          end

          declared_params
        end

      end

      def self.registered(app)
        app.helpers CurrentUser::Helpers
      end

    end

  end
end
