module Commiker
  module V0
    module UseCases

      class UseCaseBase < UseCase::Base

        def current_user
          context.current_user
        end

      end

    end
  end
end
