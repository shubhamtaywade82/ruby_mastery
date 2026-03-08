# frozen_string_literal: true
require "parser/current"
require_relative "../graph/node"
require_relative "../graph/edge"

module RubyMastery
  module Architecture
    module Builders
      class ServiceGraphBuilder < Parser::AST::Processor
        def initialize(graph)
          @graph = graph
        end

        def on_class(node)
          name, _, body = *node
          return unless service?(name)

          @current_service = Graph::Node.new(name.children.last.to_s, :service)
          @graph.add_node(@current_service)

          process(body) if body
          @current_service = nil
        end

        def handler_missing(node)
          node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
        end

        def on_send(node)
          return unless @current_service
          receiver, _method_name, *_args = *node

          if receiver && receiver.type == :const
            target_name = receiver.children.last.to_s
            target_type = target_name.end_with?("Service") ? :service : :model
            target = Graph::Node.new(target_name, target_type)
            @graph.add_edge(Graph::Edge.new(from: @current_service, to: target, type: :dependency))
          end

          super
        end

        private

        def service?(name)
          name.children.last.to_s.end_with?("Service")
        end
      end
    end
  end
end
