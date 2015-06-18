module Commiker
  module V0
    module UseCases
      module Users
        module Index

          class Base < UseCaseBase

            depends UseCases::Index

            def perform
              ctx.users = User.order('name ASC').all
            end

          end

        end
      end
    end
  end
end
