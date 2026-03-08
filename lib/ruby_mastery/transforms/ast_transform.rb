# frozen_string_literal: true
require "parser/current"

module RubyMastery
  module Transforms
    class ASTTransform < Parser::AST::Processor
      attr_reader :rewriter

      def initialize(buffer)
        @rewriter = Parser::Source::TreeRewriter.new(buffer)
      end

      def rewrite(ast)
        process(ast) if ast
        rewriter
      end
    end
  end
end
