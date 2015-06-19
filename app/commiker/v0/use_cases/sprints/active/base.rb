module Commiker
  module V0
    module UseCases
      module Sprints
        module Active

          class Base < UseCaseBase

            def perform
              ctx.sprint = Sprint.where(active: true).first

              if ctx.sprint
                # still active?
                if (ctx.sprint.ended_at.utc - Time.now.utc.end_of_day).to_i < 0
                  ctx.sprint.update_column(:active, false)

                  ctx.sprint = nil
                  ctx.status.no_content!
                else
                  ctx.status.ok!
                end
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
