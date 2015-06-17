module Commiker
  module V0
    module Serializers
      module Story

        class Show < ActiveModel::Serializer

          root false

          attributes :id

          def initialize(object, options = {})
            if options[:current_user] && options[:current_user].is_a?(User)
              @current_user = options[:current_user]
            end

            super
          end

          def bumped
            false
          end

        end

      end
    end
  end
end
