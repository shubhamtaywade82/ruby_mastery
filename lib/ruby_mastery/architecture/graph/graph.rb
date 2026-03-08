# frozen_string_literal: true
require "set"

module RubyMastery
  module Architecture
    module Graph
      class Graph
        attr_reader :nodes, :edges

        def initialize
          @nodes = Set.new
          @edges = []
        end

        def add_node(node)
          @nodes << node
        end

        def add_edge(edge)
          @edges << edge
          add_node(edge.from)
          add_node(edge.to)
        end

        def outgoing(node)
          @edges.select { |e| e.from == node }
        end

        def incoming(node)
          @edges.select { |e| e.to == node }
        end
      end
    end
  end
end
