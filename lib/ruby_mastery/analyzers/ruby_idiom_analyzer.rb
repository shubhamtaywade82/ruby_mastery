# frozen_string_literal: true
require "parser/current"
require_relative "../rules/method_rules"

module RubyMastery
  module Analyzers
    class RubyIdiomAnalyzer < AST::Processor
      attr_reader :file, :violations

      def initialize(file, ast)
        @file = file
        @violations = []
        process(ast)
      end

      def analyze
        violations
      end

      def on_for(node)
        line = node.location.expression.line
        violations << Rules::MethodRules.new(file).idiom_violation(
          line,
          "Avoid for-loops in Ruby",
          "Use each/map/select instead"
        )
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end

      def on_lvasgn(node)
        name, value = *node
        if value&.type == :lvar
          violations << Rules::MethodRules.new(file).temporary_variable(
            node.location.expression.line
          )
        end
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end
    end
  end
end
