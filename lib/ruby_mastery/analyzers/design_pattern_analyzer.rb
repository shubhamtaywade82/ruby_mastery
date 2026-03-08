# frozen_string_literal: true

module RubyMastery
  module Analyzers
    class DesignPatternAnalyzer < AST::Processor
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

      # Strategy Pattern Suggestion: Detect large case statements comparing a variable
      def on_case(node)
        _cond, *when_branches, _else_branch = *node
        if when_branches.size > 3
          violations << violation(node, "Design Pattern: Strategy", "Consider extracting this multi-branch logic into a Strategy pattern")
        end
        traverse_children(node)
      end

      # Decorator/Presenter Suggestion: Detect large numbers of formatting methods in a model
      def on_class(node)
        name, superclass, body = *node
        if rails_model?(superclass)
          formatting_methods = find_formatting_methods(body)
          if formatting_methods.size > 4
            violations << violation(node, "Design Pattern: Decorator/Presenter", "Move formatting logic into a Decorator or Presenter")
          end
        end
        traverse_children(node)
      end

      private

      def traverse_children(node)
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      def rails_model?(superclass)
        return false unless superclass
        superclass.children.include?(:ApplicationRecord)
      end

      def find_formatting_methods(body)
        return [] unless body
        nodes = body.type == :begin ? body.children : [body]
        nodes.select do |n|
          n.is_a?(Parser::AST::Node) && n.type == :def && 
          (n.children.first.to_s.include?("format") || n.children.first.to_s.include?("display"))
        end
      end

      def violation(node, message, suggestion)
        RubyMastery::Rules::BaseRule::Violation.new(
          rule: "DesignPattern",
          file: file,
          line: node.location.expression.line,
          message: message,
          suggestion: suggestion
        )
      end
    end
  end
end
