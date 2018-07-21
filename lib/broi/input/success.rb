module Broi
  class Input < Dry::Struct::Value
    class Success < Dry::Monads::Success
      def input
        value!
      end

      def errors
        Errors.new({})
      end
    end
  end
end