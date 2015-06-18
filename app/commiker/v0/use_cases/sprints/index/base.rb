module Commiker
  module V0
    module UseCases
      module Sprints
        module Index

          class Base < UseCaseBase

            depends UseCases::Index

            def perform
              context.sprints = Sprints.order('started_at DESC').all
            end

          end

        end
      end
    end
  end
end
