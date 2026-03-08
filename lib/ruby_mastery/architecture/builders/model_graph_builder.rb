# frozen_string_literal: true
require "parser/current"
require_relative "../graph/node"
require_relative "../graph/edge"

module RubyMastery
  module Architecture
    module Builders
      class ModelGraphBuilder < Parser::AST::Processor
        ASSOCIATIONS = %i[
          belongs_to
          has_many
          has_one
          has_and_belongs_to_many
        ]

        def initialize(graph)
          @graph = graph
        end

        def on_class(node)
          name, superclass, body = *node
          return unless rails_model?(superclass)

          @current_model = Graph::Node.new(name.children.last.to_s, :model)
          @graph.add_node(@current_model)

          process(body) if body
          @current_model = nil
        end

        def handler_missing(node)
          node.children.each { |c| process(c) if c.is_a?(Parser::AST::Node) }
        end

        def on_send(node)
          return unless @current_model
          _receiver, method_name, *args = *node

          if ASSOCIATIONS.include?(method_name)
            target_node = args.first
            if target_node && (target_node.type == :sym || target_node.type == :str)
              target_name = target_node.children.first.to_s.split('_').map(&:capitalize).join
              target = Graph::Node.new(target_name, :model)
              @graph.add_edge(Graph::Edge.new(from: @current_model, to: target, type: :association))
            end
          end
          
          super
        end

        private

        def rails_model?(superclass)
          return false unless superclass
          superclass.children.include?(:ApplicationRecord) || 
          superclass.children.include?(:ActiveRecord)
        end
      end
    end
  end
end
