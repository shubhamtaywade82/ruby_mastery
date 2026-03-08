# frozen_string_literal: true
require "parser/current"
require_relative "../rules/method_rules"

module RubyMastery
  module Analyzers
    class AstAnalyzer < AST::Processor
      attr_reader :file, :violations

      def initialize(file, ast)
        @file = file
        @violations = []
        process(ast)
      end

      def analyze
        violations
      end

      def on_def(node)
        method_name, args, body = *node
        line = node.location.expression.line
        length = node.location.expression.last_line - line

        rule = Rules::MethodRules.new(file)
        if length > rule.max_method_length
          violations << rule.long_method(line)
        end

        check_nesting(body) if body
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end

      def on_class(node)
        name, superclass, body = *node
        methods = if body && body.type == :begin
                    body.children.count { |c| c.is_a?(Parser::AST::Node) && c.type == :def }
                  elsif body && body.type == :def
                  else
                    0
                  end

        if methods > 20
          violations << Rules::MethodRules.new(file).large_class(
            node.location.expression.line
          )
        end
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end

      def on_for(node)
        violations << Rules::MethodRules.new(file).procedural_loop(
          node.location.expression.line
        )
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end

      private

      def check_nesting(node, depth = 0)
        return unless node.is_a?(Parser::AST::Node)

        if node.type == :if
          depth += 1
          if depth > 2
            violations << Rules::MethodRules.new(file).deep_nesting(
              node.location.expression.line
            )
          end
        end

        node.children.each do |child|
          check_nesting(child, depth)
        end
      end
    end
  end
end
