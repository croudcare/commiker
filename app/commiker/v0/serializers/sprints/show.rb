module Commiker
  module V0
    module Serializers
      module Sprints

        class Show < Base

          root false

          attributes :id,
                     :obs,
                     :starter_id,
                     :started_at,
                     :ended_at

          has_many :users, serializer: Users::Show

        end

      end
    end
  end
end
