# frozen_string_literal: true
require_relative "ast_transform"

module RubyMastery
  module Transforms
    class MethodExtractionTransform < ASTTransform
      THRESHOLD = 5

      def on_def(node)
        name, args, body = *node

        if body && body.type == :begin && body.children.length > THRESHOLD
          insert_extraction(node)
        end

        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end

      private

      def insert_extraction(node)
        comment = "# TODO: Extract workflow method\n"
        rewriter.insert_before(node.location.expression, comment)
      end
    end
  end
end
