module Broi
  class Input < Dry::Struct::Value
    class Success < Dry::Monads::Success
      def input
        value!
      end

      def errors
        {}
      end
    end
  end
end