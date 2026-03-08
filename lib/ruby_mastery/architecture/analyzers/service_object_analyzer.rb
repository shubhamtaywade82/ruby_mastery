# frozen_string_literal: true
require "parser/current"

module RubyMastery
  module Architecture
    module Analyzers
      class ServiceObjectAnalyzer < Parser::AST::Processor
        attr_reader :file, :violations

        def initialize(file, ast)
          @file = file
          @violations = []
          process(ast) if ast
        end

        def on_class(node)
          # Only run checks if we are inside the services directory
          if @file.include?("app/services")
            name_node, _superclass, body = *node
            class_name = name_node.children[1]

            methods = []
            if body && body.type == :begin
              methods = body.children.select { |c| c.is_a?(Parser::AST::Node) && (c.type == :def || c.type == :defs) }
            elsif body && (body.type == :def || body.type == :defs)
              methods = [body]
            end

            public_methods = methods.reject { |m| private_method?(m) }

            # Rule 1: Service Objects should only have one public method (usually `call`)
            if public_methods.size > 1
              @violations << {
                rule: "ServiceObjectInterface",
                file: @file,
                line: node.location.expression.line,
                message: "Service '#{class_name}' exposes #{public_methods.size} public methods. Services should expose exactly 1 public method (e.g., .call).",
                suggestion: "Refactor into separate services or hide methods behind private."
              }
            end

            # Rule 2: God Service
            if methods.size > 10
              @violations << {
                rule: "GodService",
                file: @file,
                line: node.location.expression.line,
                message: "Service '#{class_name}' is too complex (>10 methods). It is likely orchestrating too much.",
                suggestion: "Extract domain logic to Domain Models or split into smaller operations."
              }
            end
          end

          node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
        end

        private

        def private_method?(node)
          # A simplistic check. In a full system, you'd track visibility scopes.
          false
        end
      end
    end
  end
end
