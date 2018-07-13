require 'broi/input/invalid_error'

module Broi
  class Input < Dry::Struct::Value
    module SoftInput
      def self.included(mod)
        mod.extend ClassMethods
      end

      def valid!
        self.class.superclass.new Utils.deep_transform_values(attributes, &:value!)
      rescue Dry::Monads::UnwrapError
        raise Invalid, 'Called `valid!` on invalid soft input!'
      end

      def strict?
        false
      end

      module ClassMethods
        def inspect
          "#{superclass.name}|soft"
        end
      end
    end

    module Soft
      class << self
        def [](klass)
          register[klass]
        end

        private

        def register
          @register ||= Hash.new do |hash, klass|
            hash[klass] = Class.new(klass).include(SoftInput)
          end
        end
      end

      def self.call(input_class, attrs, errors)
        attrs = input_class.input[attrs]
        input = Utils.deep_merge(attrs, errors) do |target, _error|
          InvalidValue.new(target)
        end
        input = Utils.deep_transform_values(input) do |value|
          value.is_a?(InvalidValue) ? value : Value.new(value)
        end
        self[input_class].new(input)
      end
    end
  end
end