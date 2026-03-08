# frozen_string_literal: true

module RubyMastery
  module Analyzers
    class CleanCodeAnalyzer < AST::Processor
      attr_reader :file, :violations

      VAGUE_NAMES = %w[data info item obj res thing manager]

      def initialize(file, ast)
        @file = file
        @violations = []
        process(ast) if ast
      end

      def analyze; violations; end

      def handler_missing(node)
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      def on_lvasgn(node)
        name, _value = *node
        check_name(node, name)
        traverse_children(node)
      end

      def on_def(node)
        name, args, _body = *node
        check_name(node, name)
        traverse_children(node)
      end

      def on_if(node)
        _cond, body, else_branch = *node
        if body && else_branch
          violations << violation(node, "Clean Code: Else Avoidance", "Use guard clauses and early returns instead of 'else'")
        end
        traverse_children(node)
      end

      private

      def traverse_children(node)
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      def check_name(node, name)
        if VAGUE_NAMES.include?(name.to_s.downcase)
          violations << violation(node, "Clean Code: Vague Naming", "Use a domain-specific name instead of '#{name}'")
        end
      end

      def violation(node, message, suggestion)
        RubyMastery::Rules::BaseRule::Violation.new(
          rule: "CleanCode",
          file: file,
          line: node.location.expression.line,
          message: message,
          suggestion: suggestion
        )
      end
    end
  end
end
