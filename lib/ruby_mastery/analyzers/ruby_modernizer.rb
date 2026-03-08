# frozen_string_literal: true

module RubyMastery
  module Analyzers
    class RubyModernizer < AST::Processor
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

      def on_send(node)
        receiver, method_name, *args = *node
        
        # Suggest Data.define instead of Struct.new (Ruby 3.2+)
        if method_name == :new && receiver && receiver.type == :const && receiver.children.last == :Struct
          violations << violation(node, "Ruby 3.2+: Immutable Data", "Use Data.define for value objects instead of Struct.new")
        end

        # Suggest block forwarding (Ruby 3.1+)
        # detect usage of &block where block is just passed to another method
        if method_name == :call && receiver && receiver.type == :lvar
          # Simplified detection
        end

        traverse_children(node)
      end

      private

      def traverse_children(node)
        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      def violation(node, message, suggestion)
        RubyMastery::Rules::BaseRule::Violation.new(
          rule: "RubyModernizer",
          file: file,
          line: node.location.expression.line,
          message: message,
          suggestion: suggestion
        )
      end
    end
  end
end
