# frozen_string_literal: true

module RubyMastery
  module Architecture
    module Analyzers
      class CircularDependencyAnalyzer
        def initialize(graph)
          @graph = graph
        end

        def detect
          visited = {}
          stack = {}
          cycles = []

          @graph.nodes.each do |node|
            dfs(node, visited, stack, cycles)
          end

          cycles
        end

        private

        def dfs(node, visited, stack, cycles)
          return if visited[node]

          visited[node] = true
          stack[node] = true

          @graph.outgoing(node).each do |edge|
            target = edge.to

            if !visited[target]
              dfs(target, visited, stack, cycles)
            elsif stack[target]
              cycles << [node, target]
            end
          end

          stack[node] = false
        end
      end
    end
  end
end
