module Commiker
  module V0
    module UseCases
      module Stories
        module Delete

          class Base < UseCaseBase

            depends Stories::FindOne

            context_reader :story

            def perform
              if story.destroy
                ctx.status.accepted!
              else
                ctx.status.unprocessable_entity!
              end
            end

          end

        end
      end
    end
  end
end
