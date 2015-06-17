module Commiker
  module V0
    module UseCases

      class Index < UseCaseBase

        context_reader :page, :per_page

        def perform

          if "#{page}".length > 0
            begin
              context.page = Float(page).to_i
            rescue
              context.errors.push(:page, 'invalid page value')
              failure!(:bad_request)
            end
          else
            context.page = 1
          end

          if "#{per_page}".length > 0
            begin
              context.per_page = Float(per_page).to_i
            rescue
              context.errors.push(:page, 'invalid per_page value')
              failure!(:bad_request)
            end
          else
            context.per_page = 10
          end

        end

      end

    end
  end
end
