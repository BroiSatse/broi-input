module Broi
  class Input
    class Struct < Dry::Struct
      transform_keys(&:to_sym)

      class << self
        def root_for(input_class)
          Class.new(self).tap do |subclass|
            subclass.instance_variable_set(:@input_class_name, input_class.name)
          end
        end

        attr_reader :input_class_name

        def attribute(name, **opts, &block)
          if block_given?
            super name, Broi::Input::Struct, &block
          else
            type = Types::Any.optional.meta(omittable: true)
            type = type.default(opts[:default]) if opts.has_key?(:default)
            super(name, type)
          end
        end

        def build(params)
          args = Utils.deep_merge(params, new.to_h) do |param, struct|
            struct.is_a?(Hash) ? struct : param
          end
          new(args)
        end
      end
    end
  end
end
