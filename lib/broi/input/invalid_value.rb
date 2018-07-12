module Broi
  class Input < Dry::Struct::Value
    class InvalidValue
      def inspect
        '#InvalidValue'
      end
    end
  end
end
