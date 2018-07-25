require 'broi/input/invalid_error'
require 'byebug'

module Broi
  class Input
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

      def with_valid(*keys, &block)
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

        def call(input_class, attrs, errors)
          attrs = input_class.input[attrs]
          input = Utils.deep_merge(attrs, errors) do |target, error|
            next self.(target.class, target, error) if target.is_a?(Broi::Input)
            InvalidValue.new(wrap_value(target).value!)
          end
          input = Utils.deep_transform_values(input) do |value|
            wrap_value(value)
          end
          self[input_class].new(input)
        end

        private

        def register
          @register ||= Hash.new do |hash, klass|
            hash[klass] = Class.new(klass).include(SoftInput)
          end
        end

        def wrap_value(value)
          return value if [Broi::Input, Value, InvalidValue].any? { |klass| value.is_a? klass}
          Value.new(value)
        end
      end
    end
  end
end