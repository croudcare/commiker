module Commiker
  module V0
    module UseCases
      module Stories
        module Index

          class Base < UseCaseBase

            depends UseCases::Index

            def perform
              context.stories = []
              # \
              #   Repos::GemPost.query({
              #     where: { is_published: true },
              #     page: context.page,
              #     per_page: context.per_page
              #   }).all
            end

          end

        end
      end
    end
  end
end
