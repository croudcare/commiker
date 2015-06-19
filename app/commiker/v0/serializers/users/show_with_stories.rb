module Commiker
  module V0
    module Serializers
      module Users

        class ShowWithStories < Base

          attributes :id,
                     :slack_uid,
                     :slack_handler,
                     :stories

          def initialize(object, options = {})
            if options[:stories]
              @stories = options[:stories]
            end

            super
          end

          def stories
            @stories.map{ |story| Stories::ShowLess.new(story) }
          end

        end

      end
    end
  end
end
