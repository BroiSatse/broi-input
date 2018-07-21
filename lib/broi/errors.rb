module Broi
  # TODO: Separate gem?
  class Errors
    include Enumerable

    def initialize(error_hash = {})
      @errors = errorize_hash(error_hash)
    end

    def to_nested_hash
      Broi::Input::Utils.deep_transform_values(@errors) do |value|
        value.respond_to?(:to_nested_hash) ? value.to_nested_hash : value
      end
    end

    def to_flat_hash
      result = {}
      @errors.each do |key, value|
        if value.respond_to?(:to_flat_hash)
          value.to_flat_hash.each do |inner_key, inner_value|
            result[:"#{key}.#{inner_key}"] = inner_value.dup
          end
        else
          result[key] = value.dup
        end
      end
      result
    end

    def each(&block)
      to_flat_hash.each(&block)
    end

    def [](key)
      key, nested = key.to_s.split('.', 2)
      return unless (result = @errors[key.to_sym])
      return result unless nested
      result[nested]
    end

    alias empty? none?

    private

    def errorize_hash(hash)
      hash.map {|k, v| [k.to_sym, v.is_a?(Hash) ? Errors.new(errorize_hash(v)) : v] }.to_h
    end
  end
end
