module Commiker
  module V0
    module Serializers
      module Stories

        class ShowLess < Base

          attributes :id,
                     :pivotal_id,
                     :description,
                     :completion_percentage

        end

      end
    end
  end
end
