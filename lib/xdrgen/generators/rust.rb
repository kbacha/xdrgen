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
          when AST::Definitions::Struct
            render_struct(out, member)
          when AST::Definitions::Enum
            render_enum(out, member)
          when AST::Definitions::Union
          end
        end
      end

      def render_namespace_index(out, ns)
        out.puts "mod #{ns.name.underscore} {"
        out.indent do
          render_definitions_index(out, ns)
          out.unbreak
        end
        out.puts '}'
      end

      def render_struct(out, struct)
        out.puts '#[derive(Debug, Deserialize, Serialize, Clone, PartialEq)]'
        out.puts "struct #{struct.name.camelize} {"

        out.indent do
          struct.members.each do |m|
            if m.declaration == AST::Declarations::Opaque && m.declaration.fixed?
              out.puts '#[serde(with = "serde_xdr::opaque_data::fixed_length")]'
            end
            out.puts "#{m.name.underscore}: #{decl_string(m.declaration)},"
          end
        end

        out.puts '}'
        out.break
      end

      def render_enum(out, enum)
        out.puts '#[derive(Debug, Deserialize, Serialize, Clone, PartialEq)]'
        out.puts "enum #{enum.name.camelize} {"
        out.puts '}'
        out.break
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

      def decl_string(decl)
        case decl
        when AST::Declarations::Opaque ;
          if decl.fixed?
            "[u8; #{decl.size}]"
          else
            'serde_bytes::Bytes'
          end
        when AST::Declarations::String
          'String'
        when AST::Declarations::Array
          # TODO: array types
        when AST::Declarations::Optional
          "Option<#{type_string(decl.type)}>"
          # TODO: Capture as option type
        when AST::Declarations::Simple
          type_string(decl.type)
        when AST::Declarations::Void
          '()'
        when AST::Concerns::NestedDefinition
          type.name.camelize
        else
          raise "Unknown declaration type: #{decl.class.name}"
        end
      end

      def type_string(type)
        case type
        when AST::Typespecs::Int
          'i32'
        when AST::Typespecs::UnsignedInt
          'u32'
        when AST::Typespecs::Hyper
          'i64'
        when AST::Typespecs::UnsignedHyper
          'u64'
        when AST::Typespecs::Float
          'f32'
        when AST::Typespecs::Double
          'f64'
        when AST::Typespecs::Quadruple
          'f64'
        when AST::Typespecs::Bool
          'bool'
        when AST::Typespecs::Simple
          type.text_value.camelize
        when AST::Concerns::NestedDefinition
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
