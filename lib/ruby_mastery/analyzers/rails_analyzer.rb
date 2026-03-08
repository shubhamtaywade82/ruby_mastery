# frozen_string_literal: true
require "parser/current"
require_relative "../rules/object_model_rules"

module RubyMastery
  module Analyzers
    class RailsAnalyzer < AST::Processor
      attr_reader :file, :violations

      def initialize(file, ast)
        @file = file
        @violations = []
        process(ast)
      end

      def analyze
        violations
      end

      def on_class(node)
        name, superclass, body = *node
        if superclass && superclass.type == :const && superclass.children.include?(:ApplicationController)
          detect_controller_issues(node)
        end
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end

      private

      def detect_controller_issues(node)
        name, superclass, body = *node
        return unless body
        methods = if body.type == :begin
                    body.children.select { |c| c.is_a?(Parser::AST::Node) && c.type == :def }
                  elsif body.type == :def
                    [body]
                  else
                    []
                  end

        if methods.size > 10
          violations << Rules::ObjectModelRules.new(file).fat_controller(
            node.location.expression.line
          )
        end
      end
    end
  end
end
