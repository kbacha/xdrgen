module Xdrgen
  module Generators
    class Rust
      class Comment < Dry::Struct
        attribute :text, Types::String

        def render(out)
          text.split("\n").each do |line|
            out.puts "// #{line}"
          end
        end
      end
    end
  end
end
