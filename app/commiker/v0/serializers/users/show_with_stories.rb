module Commiker
  module V0
    module Serializers
      module Users

        class ShowWithStories < Base

          attributes :id,
                     :name,
                     :email,
                     :slack_uid,
                     :slack_handler,
                     :avatar_url,
                     :avatar_32_url,
                     :avatar_72_url,
                     :stories,
                     :completion_percentage

          def initialize(object, options = {})
            if options[:stories]
              @stories = options[:stories]
            end

            super
          end

          def stories
            @stories.map{ |story| Stories::ShowLess.new(story) }
          end

          def completion_percentage
            total = (@stories.count * 100)

            return 0 if (total == 0)

            completion_sum = @stories.map(&:completion_percentage).sum

            (completion_sum * 100 / total)
          end

        end

      end
    end
  end
end
