# frozen_string_literal: true

module RubyMastery
  module Architecture
    module Analyzers
      class AggregateBoundaryAnalyzer
        def initialize(graph)
          @graph = graph
        end

        def violations
          @graph.nodes.select do |node|
            edges = @graph.outgoing(node)
            edges.count { |e| e.type == :association } > 5
          end
        end
      end
    end
  end
end
