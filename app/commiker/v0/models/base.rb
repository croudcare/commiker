module Commiker
  module V0

    class Base < ActiveRecord::Base

      self.abstract_class = true

      def methods_to_hash(*args)
        {}.tap do |h|
          args.each do |key|
            h[key] = self.send(key)
          end
        end
      end

    end

  end
end
