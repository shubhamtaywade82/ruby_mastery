# frozen_string_literal: true
require_relative "ast_transform"

module RubyMastery
  module Transforms
    class GuardClauseTransform < ASTTransform
      def on_if(node)
        condition, body, else_branch = *node

        if body&.type == :return && else_branch.nil?
          condition_src = condition.location.expression.source
          replacement = "return if #{condition_src}"
          rewriter.replace(node.location.expression, replacement)
        end

        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end
    end
  end
end
