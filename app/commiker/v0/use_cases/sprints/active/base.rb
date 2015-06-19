module Commiker
  module V0
    module UseCases
      module Sprints
        module Active

          class Base < UseCaseBase

            def perform
              ctx.sprint = Sprint.where(active: true).first

              if ctx.sprint
                ctx.status.ok!
              else
                ctx.status.no_content!
              end
            end

          end

        end
      end
    end
  end
end
