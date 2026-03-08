# frozen_string_literal: true
require "parser/current"

module RubyMastery
  module Analyzers
    class RailsDomainAnalyzer < AST::Processor
      attr_reader :file, :violations

      CALLBACKS = %i[
        before_save
        after_save
        before_create
        after_create
        after_commit
        after_update
      ]

      def initialize(file, ast)
        @file = file
        @violations = []
        process(ast) if ast
      end

      def analyze
        violations
      end

      def on_class(node)
        name, superclass, body = *node

        return unless rails_model?(superclass)

        methods = instance_methods(body)
        callbacks = callback_calls(body)

        check_anemic_model(node, methods)
        check_god_model(node, methods)
        check_callback_abuse(node, callbacks)

        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      private

      def rails_model?(superclass)
        return false unless superclass

        # Check for ApplicationRecord or similar Base model
        superclass.children.include?(:ApplicationRecord) || 
        superclass.children.include?(:ActiveRecord)
      end

      def instance_methods(body)
        return [] unless body

        if body.type == :begin
          body.children.select { |c| c.is_a?(Parser::AST::Node) && c.type == :def }
        elsif body.type == :def
          [body]
        else
          []
        end
      end

      def callback_calls(body)
        return [] unless body

        nodes = if body.type == :begin
                  body.children
                else
                  [body]
                end

        nodes.select do |node|
          node.is_a?(Parser::AST::Node) &&
          node.type == :send && 
          CALLBACKS.include?(node.children[1])
        end
      end

      def check_anemic_model(node, methods)
        if methods.size <= 1
          violations << violation(
            node,
            "Anemic domain model",
            "Move domain logic into the model"
          )
        end
      end

      def check_god_model(node, methods)
        if methods.size > 25
          violations << violation(
            node,
            "God model detected",
            "Split domain responsibilities"
          )
        end
      end

      def check_callback_abuse(node, callbacks)
        if callbacks.size > 4
          violations << violation(
            node,
            "Callback abuse detected",
            "Prefer explicit domain workflows"
          )
        end
      end

      def violation(node, message, suggestion)
        RubyMastery::Rules::BaseRule::Violation.new(
          rule: "RailsDomainAnalyzer",
          file: file,
          line: node.location.expression.line,
          message: message,
          suggestion: suggestion
        )
      end
    end
  end
end
