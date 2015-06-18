module Commiker
  module V0
    module Serializers
      module Users

        class Index < Base

          has_many :users, serializer: Users::Show

        end

      end
    end
  end
end
