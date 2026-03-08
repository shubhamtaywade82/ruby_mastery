# frozen_string_literal: true
require "parser/current"

module RubyMastery
  module Architecture
    module Analyzers
      class AnemicModelAnalyzer < Parser::AST::Processor
        attr_reader :file, :violations

        def initialize(file, ast)
          @file = file
          @violations = []
          process(ast) if ast
        end

        def on_class(node)
          name_node, superclass_node, body = *node
          
          is_active_record = superclass_node && 
                             superclass_node.type == :const && 
                             superclass_node.children[1] == :ApplicationRecord

          if is_active_record
            class_name = name_node.children[1]
            
            # Look for instance methods defining business logic
            methods = []
            if body && body.type == :begin
              methods = body.children.select { |c| c.is_a?(Parser::AST::Node) && c.type == :def }
            elsif body && body.type == :def
              methods = [body]
            end

            # Check if it has scopes, validations, relations but NO methods
            if methods.empty?
              @violations << {
                rule: "AnemicDomainModel",
                file: @file,
                line: node.location.expression.line,
                message: "Model '#{class_name}' is anemic. It lacks business logic methods and acts only as a data bag.",
                suggestion: "Move domain logic from Services or Controllers into this Model."
              }
            end
          end

          node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
        end
      end
    end
  end
end
