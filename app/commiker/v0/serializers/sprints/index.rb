module Commiker
  module V0
    module Serializers
      module Sprints

        class Index < Base

          has_many :sprints, serializer: Sprints::Show

        end

      end
    end
  end
end
