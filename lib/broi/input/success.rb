module Broi
  class Input
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