module Commiker
  module V0
    module Serializers
      module Users

        class Show < Base

          attributes :id,
                     :name,
                     :email,
                     :slack_uid,
                     :slack_handler,
                     :avatar_url,
                     :avatar_32_url

        end

      end
    end
  end
end
