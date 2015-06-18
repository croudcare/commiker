module Commiker
  module V0
    module Serializers

      class Base < ActiveModel::Serializer

        def initialize(object, options = {})
          if options[:current_user] && options[:current_user].is_a?(User)
            @current_user = options[:current_user]
          end

          super
        end

      end

    end
  end
end
