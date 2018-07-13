module Broi
  class Input < Dry::Struct::Value
    Invalid = Class.new(StandardError)
  end
end
