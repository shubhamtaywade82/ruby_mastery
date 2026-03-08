# frozen_string_literal: true

require "parser/current"

module RubyMastery
  module Refactors
    class ReplaceLoop < BaseRefactor
      class Rewriter < Parser::TreeRewriter
        def on_for(node)
          variable, collection, body = *node
          replace(node.loc.expression, "#{collection.loc.expression.source}.each { |#{variable.loc.expression.source}| #{body.loc.expression.source} }")
        end
      end

      def transform(source)
        buffer, ast = parse(source)
        Rewriter.new.rewrite(buffer, ast)
      end
    end
  end
end
