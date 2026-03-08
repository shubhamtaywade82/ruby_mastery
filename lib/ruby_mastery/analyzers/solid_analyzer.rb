# frozen_string_literal: true

module RubyMastery
  module Analyzers
    class SolidAnalyzer < AST::Processor
      attr_reader :file, :violations

      def initialize(file, ast)
        @file = file
        @violations = []
        process(ast) if ast
      end

      def analyze; violations; end

      def handler_missing(node)
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      # DIP: Detect hardcoded constant instantiation (Dependency Inversion)
      def on_send(node)
        receiver, method_name, *_args = *node
        if method_name == :new && receiver && receiver.type == :const
          # We flag .new calls inside instance methods as potential DIP violations
          # unless it's a known Value Object or internal helper
          violations << violation(node, "Potential DIP Violation", "Inject dependency instead of hardcoding #{receiver.children.last}.new")
        end
        traverse_children(node)
      end

      private

      def traverse_children(node)
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      def violation(node, message, suggestion)
        RubyMastery::Rules::BaseRule::Violation.new(
          rule: "SOLID:DIP",
          file: file,
          line: node.location.expression.line,
          message: message,
          suggestion: suggestion
        )
      end
    end
  end
end
