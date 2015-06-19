module Commiker
  module V0
    module Serializers
      module Stories

        class BulkCreate < Base

          has_many :created_stories, serializer: Stories::Show
          has_many :invalid_stories
          has_many :duplicated_stories

        end

      end
    end
  end
end
