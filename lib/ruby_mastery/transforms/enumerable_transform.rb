# frozen_string_literal: true
require_relative "ast_transform"

module RubyMastery
  module Transforms
    class EnumerableTransform < ASTTransform
      def on_for(node)
        variable, collection, body = *node

        collection_src = collection.location.expression.source
        variable_src = variable.children.first

        new_loop = "#{collection_src}.each do |#{variable_src}|"
        rewriter.replace(node.location.keyword, new_loop)

        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end
    end
  end
end
