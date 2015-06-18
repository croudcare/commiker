module Commiker
  module V0
    module Serializers
      module Stories

        class Show < Base

          attributes :id,
                     :sprint_id,
                     :user_id,
                     :pivotal_id,
                     :description

        end

      end
    end
  end
end
