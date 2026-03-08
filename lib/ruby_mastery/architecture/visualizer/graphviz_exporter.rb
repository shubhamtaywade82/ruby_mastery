module RubyMastery
  module Architecture
    module Visualizer
      class GraphvizExporter
        def initialize(graph)
          @graph = graph
        end

        def export
          lines = []
          lines << "digraph rails_architecture {"
          lines << "rankdir=LR;"

          @graph.nodes.each do |node|
            lines << node_definition(node)
          end

          @graph.edges.each do |edge|
            lines << edge_definition(edge)
          end

          lines << "}"

          lines.join("\n")
        end

        private

        def node_definition(node)
          color =
            case node.type
            when :model then "lightblue"
            when :service then "orange"
            when :controller then "lightgreen"
            else "white"
            end

          "#{node.name} [style=filled, fillcolor=#{color}];"
        end

        def edge_definition(edge)
          "#{edge.from.name} -> #{edge.to.name} [label=\"#{edge.type}\"];"
        end
      end
    end
  end
end
