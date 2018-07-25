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
require 'broi/input/struct'

module Broi
  class Input

    module Types
      include Dry::Types.module
    end

    def initialize(params = {})
      result = self.class.schema.(params)
      @valid = result.success?
      @struct = self.class.struct.build(result.output)
      @errors = Errors.new result.errors
    end

    attr_reader :errors, :struct

    def valid?
      @valid
    end

    def [](key)
      key, nested = key.to_s.split('.', 2)
      return unless (result = super(key.to_sym))
      result = result[nested] if nested
      result
    end

    class << self
      def attribute(*args, &block)
        struct.attribute(*args, &block)
      end

      def validate(&block)
        @schema = Dry::Validation::Schema(&block)
      end

      def call(params = {})
        new(params)
      end

      def schema
        @schema ||= Dry::Validation.Schema {}
      end

      def struct
        @struct ||= Broi::Input::Struct.root_for(self)
      end
    end
  end
end