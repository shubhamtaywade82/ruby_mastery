# frozen_string_literal: true
require "parser/current"
require_relative "../graph/node"
require_relative "../graph/edge"

module RubyMastery
  module Architecture
    module Builders
      class ControllerGraphBuilder < Parser::AST::Processor
        def initialize(graph)
          @graph = graph
        end

        def on_class(node)
          name, _superclass, body = *node
          return unless controller?(name)

          @current_controller = Graph::Node.new(name.children.last.to_s, :controller)
          @graph.add_node(@current_controller)

          process(body) if body
          @current_controller = nil
        end

        def handler_missing(node)
          node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
        end

        def on_send(node)
          return unless @current_controller
          receiver, _method_name, *_args = *node

          if receiver && receiver.type == :const
            target_name = receiver.children.last.to_s
            target_type = target_name.end_with?("Service") ? :service : :model
            target = Graph::Node.new(target_name, target_type)
            @graph.add_edge(Graph::Edge.new(from: @current_controller, to: target, type: :invocation))
          end

          super
        end

        private

        def controller?(name)
          name.children.last.to_s.end_with?("Controller")
        end
      end
    end
  end
end
