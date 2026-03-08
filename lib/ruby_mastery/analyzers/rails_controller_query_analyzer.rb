# frozen_string_literal: true

module RubyMastery
  module Analyzers
    class ControllerQueryAnalyzer < AST::Processor
      attr_reader :file, :violations

      QUERY_METHODS = %i[where find joins includes]

      def initialize(file, ast)
        @file = file
        @violations = []
        process(ast) if ast
      end

      def analyze
        violations
      end

      def handler_missing(node)
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      def on_send(node)
        _receiver, method_name, *_args = *node

        if is_controller? && QUERY_METHODS.include?(method_name)
          violations << RubyMastery::Rules::BaseRule::Violation.new(
            rule: "ControllerQueryAnalyzer",
            file: file,
            line: node.location.expression.line,
            message: "Query logic inside controller",
            suggestion: "Move query into model scope"
          )
        end

        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      private

      def is_controller?
        file.include?("app/controllers")
      end
    end
  end
end
