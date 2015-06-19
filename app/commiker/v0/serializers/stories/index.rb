module Commiker
  module V0
    module Serializers
      module Stories

        class Index < Base

          has_many :stories, serializer: Stories::Show

        end

      end
    end
  end
end
