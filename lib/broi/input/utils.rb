module Broi
  class Input
    module Utils
      extend self

      def deep_transform_values(object, &block)
        if object.is_a?(Hash)
          object.transform_values { |value| deep_transform_values(value, &block) }
        else
          block.(object)
        end
      end

      def deep_merge(target, source, &block)
        if target.is_a?(Hash) && source.is_a?(Hash)
          keys = (target.keys + source.keys).uniq
          keys.map do |key|
            value = if [target, source].all? { |h| h.key? key }
              deep_merge(target[key], source[key], &block)
            else
              [target[key], source[key]].compact.first
            end
            [key, value]
          end.to_h
        else
          block ||= ->(_target, source) { source }
          block.(target, source)
        end
      end
    end
  end
end