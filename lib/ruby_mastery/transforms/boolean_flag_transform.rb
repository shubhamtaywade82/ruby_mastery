# frozen_string_literal: true
require_relative "ast_transform"

module RubyMastery
  module Transforms
    class BooleanFlagTransform < ASTTransform
      def on_send(node)
        receiver, method_name, *args = *node

        args.each do |arg|
          if arg.type == :true || arg.type == :false
            comment = "# TODO: Replace boolean flag argument\n"
            rewriter.insert_before(node.location.expression, comment)
          end
        end

        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end
    end
  end
end
