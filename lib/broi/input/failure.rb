module Broi
  class Input
    class Failure < Dry::Monads::Failure
      def initialize(input, errors)
        @input = input
        super(errors)
      end

      attr_reader :input

      def errors
        failure
      end
    end
  end
end