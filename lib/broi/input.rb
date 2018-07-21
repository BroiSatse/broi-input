require 'dry-struct'
require 'dry/validation'
require 'dry/monads/result'

require 'broi/errors'
require 'broi/input/success'
require 'broi/input/failure'
require 'broi/input/utils'
require 'broi/input/value'
require 'broi/input/invalid_value'
require 'broi/input/soft'

module Broi
  class Input < Dry::Struct::Value

    module Types
      include Dry::Types.module
    end

    transform_keys(&:to_sym)

    def strict?
      true
    end

    class << self

      def attribute(name, **opts, &block)
        type = Types::Any.optional.meta(omittable: true)
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
        input = Soft.(self, result.output, result.errors)
        if result.success?
          Success.new(input)
        else
          Failure.new(input, Errors.new(result.errors))
        end
      end

      private

      def merge_error(input_value, error)
        if input_value.is_a? Hash

        else
          error ? InvalidValue.new : input_value
        end
      end
    end
  end
end