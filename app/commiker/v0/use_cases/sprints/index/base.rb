module Commiker
  module V0
    module UseCases
      module Sprints
        module Index

          class Base < UseCaseBase

            depends UseCases::Index

            def perform
              context.sprints = \
                Sprint
                  .order('ended_at DESC')
                  .page(ctx.page)
                  .per(ctx.per_page)
            end

          end

        end
      end
    end
  end
end
