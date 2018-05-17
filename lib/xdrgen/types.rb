module Xdrgen
  module Types
    include Dry::Types.module

    CamelCaseString = Strict::String.constructor { |v| v.underscore.camelize }
    UnderscoreString = Strict::String.constructor(&:underscore)
  end
end
