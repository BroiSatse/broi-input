require 'dry-struct'
require 'dry/validation'
require 'dry/monads/result'

require 'broi/input/success'
require 'broi/input/failure'
require 'broi/input/utils'
require 'broi/input/value'
require 'broi/input/invalid_value'
require 'broi/input/soft'

require 'byebug'

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
        # output = input[result.output]
        # input = Utils.deep_merge(output, result.errors) do |target, _error|
        #   InvalidValue.new(target)
        # end
        # input = Utils.deep_transform_values(input) do |value|
        #   value.is_a?(InvalidValue) ? value : Value.new(value)
        # end
        # input = new(input)
        if result.success?
          Success.new(input)
        else
          Failure.new(input, result.errors)
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