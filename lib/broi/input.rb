require 'dry-struct'
require 'dry/transaction'
require 'dry/validation'

module Broi
  class Input < Dry::Struct::Value
    # include Dry::Transaction

    module Types
      include Dry::Types.module
    end

    transform_keys(&:to_sym)

    class << self
      def attribute(name, type = nil, **opts, &block)
        type ||= Types::Any
        type = type.optional.meta(omittable: true)
        type = type.default(opts[:default]) if opts.has_key?(:default)
        super(name, type, &block)
      end

      def validate(&block)
        @validation = Dry::Validation::Schema(&block)
      end

      def validation
        @validation ||= Dry::Validation.Schema {}
      end

      def call(params = {})
        result = validation.(params)
        if result.success?
          Dry::Monads::Success.new new(result.output)
        else
          Dry::Monads::Failure.new result.errors
        end
      end
    end
  end
end