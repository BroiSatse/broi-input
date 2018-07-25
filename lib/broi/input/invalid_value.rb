module Broi
  class Input
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
