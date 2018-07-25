module Broi
  class Input
    class Value < Dry::Monads::Success
      def inspect
        "#Value(#{value!.inspect})"
      end

      def valid?
        true
      end

      def invalid?
        false
      end
    end
  end
end
