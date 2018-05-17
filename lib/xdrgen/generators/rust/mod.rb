module Xdrgen
  module Generators
    class Rust
      class Mod < Dry::Struct
        attribute :identifier, Types::UnderscoreString
        attribute(
          :inners,
          Types::Array.of(Renderable).default([])
        )

        def render(out)
          out.puts "mod #{identifier} {"
          out.indent(2) do
            inners.each { |i| i.render(out) }
            out.unbreak
          end
          out.puts '}'
        end
      end
    end
  end
end
