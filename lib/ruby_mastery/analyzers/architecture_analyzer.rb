# frozen_string_literal: true
require "parser/current"
require_relative "../rules/object_model_rules"

module RubyMastery
  module Analyzers
    class ArchitectureAnalyzer < AST::Processor
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
        instance_methods = []
        class_methods = []

        if body && body.type == :begin
          body.children.each do |child|
            next unless child.is_a?(Parser::AST::Node)
            class_methods << child if child.type == :defs
            instance_methods << child if child.type == :def
          end
        elsif body
          class_methods << body if body.type == :defs
          instance_methods << body if body.type == :def
        end

        if instance_methods.empty? && class_methods.any?
          violations << Rules::ObjectModelRules.new(file).procedural_class(
            node.location.expression.line
          )
        end
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }      end
    end
  end
end
