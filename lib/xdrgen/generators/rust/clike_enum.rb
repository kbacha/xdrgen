module Xdrgen
  module Generators
    class Rust
      class ClikeEnum < Dry::Struct
        attribute :identifier, Types::CamelCaseString
      end
    end
  end
end
