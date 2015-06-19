module Commiker
  module V0
    module UseCases
      module Users
        module FindOrCreate

          class Base < UseCaseBase

            context_reader :slack_uid,
                           :omniauth_data

            def perform
              ctx.user = \
                Users::FindOne.perform(slack_uid: slack_uid).user

              ctx.user = \
                if ctx.user
                  update_user
                else
                  create_user
                end
            end

            def create_user
              creatable_info = updatable_info.merge({
                slack_uid: slack_uid,
                registration_complete: true
              })

              user = User.create(creatable_info)

              if user.save
                user
              end
            end

            def update_user
              ctx.user.update_attributes(updatable_info)
              ctx.user
            end

            def updatable_info
              {
                name: omniauth_data['info']['name'],
                email: omniauth_data['info']['email'],
                avatar_url: omniauth_data['info']['image'],
                avatar_32_url: (omniauth_data['extra']['user_info']['user']['profile']['image_32'] rescue ''),
                avatar_72_url: (omniauth_data['extra']['user_info']['user']['profile']['image_72'] rescue ''),
                slack_handler: omniauth_data['info']['nickname']
              }
            end

          end

        end
      end
    end
  end
end
