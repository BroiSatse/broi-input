module Broi
  class Input < Dry::Struct::Value
    class InvalidValue < Dry::Monads::Failure
      def inspect
        "#InvalidValue(#{failure.inspect})"
      end

      def valid?
        false
      end

      def invalid?
        true
      end
    end
  end
end
