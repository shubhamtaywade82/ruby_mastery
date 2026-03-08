# frozen_string_literal: true

module RubyMastery
  module Architecture
    module Analyzers
      class DomainClusterAnalyzer
        def initialize(graph)
          @graph = graph
        end

        def clusters
          groups = Hash.new { |h, k| h[k] = [] }

          @graph.edges.each do |edge|
            groups[edge.from] << edge.to
          end

          groups
        end
      end
    end
  end
end
