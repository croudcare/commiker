module Commiker
  module V0
    module UseCases
      module Sprints
        module CommunicatePusher

          class Base < UseCaseBase

            context_reader :sprint

            def perform
              if Configs['USE_PUSHER'] == true
                if sprint
                  Pusher['commiker_dev']
                    .trigger('sprints.show', Serializers::Sprints::Show.new(ctx.sprint))
                else
                  puts '!!!No sprint given to communicate, somethings wrong?!!!'
                end
              end
            end

          end

        end
      end
    end
  end
end
