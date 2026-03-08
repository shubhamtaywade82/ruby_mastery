# frozen_string_literal: true

module RubyMastery
  module Architecture
    module Analyzers
      class TransactionBoundaryAnalyzer
        def initialize(graph)
          @graph = graph
        end

        def violations
          @graph.nodes.select do |node|
            next unless node.type == :service

            deps = @graph.outgoing(node)
            models = deps.select { |d| d.to.type == :model }

            models.size > 3
          end
        end
      end
    end
  end
end
