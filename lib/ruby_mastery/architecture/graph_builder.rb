# frozen_string_literal: true
require "parser/current"

module RubyMastery
  module Architecture
    class GraphBuilder < Parser::AST::Processor
      attr_reader :classes, :dependencies

      def initialize(ast)
        @classes = []
        # Maps a class to the constants it references
        @dependencies = Hash.new { |h, k| h[k] = [] }
        @current_scope = []
        
        process(ast) if ast
        @dependencies.each { |k, v| v.uniq! }
      end

      def on_class(node)
        name_node, superclass_node, body = *node
        
        class_name = extract_const_name(name_node)
        return unless class_name

        @classes << class_name
        @current_scope.push(class_name)

        if superclass_node && superclass_node.type == :const
          super_name = extract_const_name(superclass_node)
          @dependencies[class_name] << super_name if super_name
        end

        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
        
        @current_scope.pop
      end

      def on_module(node)
        name_node, body = *node
        module_name = extract_const_name(name_node)
        
        if module_name
          @classes << module_name
          @current_scope.push(module_name)
        end

        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
        
        @current_scope.pop if module_name
      end

      def on_const(node)
        scope, name = *node
        
        if @current_scope.any? && name
          @dependencies[@current_scope.last] << name.to_s
        end

        node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
      end

      private

      def extract_const_name(node)
        return nil unless node && node.type == :const
        _scope, name = *node
        name.to_s
      end
    end
  end
end
