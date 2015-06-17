module Commiker
  module V0
    module UseCases
      module Users
        module Update

          class ParseParams < UseCaseBase

            context_reader :user_attributes

            def perform
              context.user_attributes = user_attributes.slice('email')
            end

          end

        end
      end
    end
  end
end
