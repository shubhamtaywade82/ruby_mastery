# frozen_string_literal: true

module RubyMastery
  module Analyzers
    class ServiceObjectAnalyzer < AST::Processor
      attr_reader :file, :violations

      def initialize(file, ast)
        @file = file
        @violations = []
        process(ast) if ast
      end

      def analyze
        violations
      end

      def on_class(node)
        name, _superclass, body = *node

        return unless service_class?(name)

        if call_method?(body)
          violations << violation(node)
        end

        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      private

      def service_class?(name)
        # Check if the class name ends with "Service"
        name.children.last.to_s.end_with?("Service")
      end

      def call_method?(body)
        return false unless body

        nodes = if body.type == :begin
                  body.children
                else
                  [body]
                end

        nodes.any? do |node|
          node.is_a?(Parser::AST::Node) &&
          node.type == :defs && 
          node.children[1] == :call
        end
      end

      def violation(node)
        RubyMastery::Rules::BaseRule::Violation.new(
          rule: "ServiceObjectAnalyzer",
          file: file,
          line: node.location.expression.line,
          message: "Service object may contain domain logic",
          suggestion: "Move behavior into domain model"
        )
      end
    end
  end
end
