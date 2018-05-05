module Xdrgen
  module Generators
    class Rust < Xdrgen::Generators::Base
      def generate
        out = @output.open("#{@namespace || 'rust_generated'}.rs")
        render_top_matter(out)
        render_definitions_index(out, @top)
        render_bottom_matter(out)
      end

      private

      def render_definitions_index(out, node)
        node.definitions.each do |member|
          case member
          when AST::Definitions::Namespace
            render_namespace_index(out, member)
          when AST::Definitions::Typedef
            render_typedef(out, member)
          when AST::Definitions::Const
            render_const(out, member)
          when AST::Definitions::Struct,
               AST::Definitions::Union,
               AST::Definitions::Enum
          end
        end
      end

      def render_namespace_index(out, ns)
        out.puts "mod #{ns.name.underscore} {"
        out.indent do
          out.break
          render_definitions_index(out, ns)
          out.unbreak
        end
        out.puts '}'
      end

      def render_typedef(out, typedef)
        # TODO: Implement the type definitions. These may be aliases or they might
        # be actual types. If it's an enum, struct, or union it should be an actual type.
        #
        # If it's a primitive then it's an alias.
      end

      def render_const(out, member)
        # TODO: Keep a symbol table and write out the actual constant values
      end

      def type_string(type)
        case type
        when AST::Typespecs::Int ;
          "i32"
        when AST::Typespecs::UnsignedInt ;
          "u32"
        when AST::Typespecs::Hyper ;
          "i64"
        when AST::Typespecs::UnsignedHyper ;
          "u64"
        when AST::Typespecs::Float ;
          "f32"
        when AST::Typespecs::Double ;
          "f64"
        when AST::Typespecs::Quadruple ;
          "f64"
        when AST::Typespecs::Bool ;
          "bool"
        when AST::Typespecs::Simple ;
          type.text_value.camelize
        when AST::Concerns::NestedDefinition ;
          type.name.camelize
        else
          raise "Unknown type: #{type.class.name}"
        end
      end

      def render_top_matter(out)
        out.puts <<-RUST.gsub(/^\s*/, '')
          //!  This module is auto generated from the following files:
          //!
          //!    #{@output.source_paths.join("\n//!    ")}
          //!
          //!  DO NOT EDIT or your changes may be overwritten
          use serde_bytes::ByteBuf;
        RUST
        out.break
      end

      def render_bottom_matter(out)
      end
    end
  end
end
