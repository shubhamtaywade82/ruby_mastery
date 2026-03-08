# frozen_string_literal: true
require "json"
require "find"
require "parser/current"

require_relative "../architecture/graph/graph"
require_relative "../architecture/builders/model_graph_builder"
require_relative "../architecture/builders/service_graph_builder"
require_relative "../architecture/builders/controller_graph_builder"
require_relative "../architecture/analyzers/circular_dependency_analyzer"
require_relative "../architecture/analyzers/domain_cluster_analyzer"
require_relative "../architecture/analyzers/aggregate_boundary_analyzer"
require_relative "../architecture/analyzers/transaction_boundary_analyzer"

module RubyMastery
  module Agent
    class ContextGenerator
      def self.generate(path)
        puts "==> Building Structural Domain Graph..."
        
        graph = Architecture::Graph::Graph.new
        
        ruby_files = if File.directory?(path)
                       Find.find(path).select { |f| f.end_with?(".rb") }
                     else
                       [path]
                     end

        # 1. Build Graph from all files
        ruby_files.each do |file|
          begin
            buffer = Parser::Source::Buffer.new(file)
            buffer.source = File.read(file)
            ast = Parser::CurrentRuby.new.parse(buffer)
            next unless ast

            Architecture::Builders::ModelGraphBuilder.new(graph).process(ast)
            Architecture::Builders::ServiceGraphBuilder.new(graph).process(ast)
            Architecture::Builders::ControllerGraphBuilder.new(graph).process(ast)
          rescue StandardError
            # Skip unparseable files
          end
        end

        # 2. Run Graph Analyzers
        circular = Architecture::Analyzers::CircularDependencyAnalyzer.new(graph).detect
        clusters = Architecture::Analyzers::DomainClusterAnalyzer.new(graph).clusters
        aggregate_violations = Architecture::Analyzers::AggregateBoundaryAnalyzer.new(graph).violations
        transaction_violations = Architecture::Analyzers::TransactionBoundaryAnalyzer.new(graph).violations

        prompt = <<~PROMPT
          # System Architect AI Context (V2 - Graph Based)
          
          You are a Senior Ruby Architect Agent. Below is the structural state of the requested Rails repository.
          
          ## 1. Domain Clusters (Connectivity)
          #{clusters.map { |k, v| "- #{k}: #{v.join(', ')}" }.join("\n")}
          
          ## 2. Architectural Analysis
          - **Circular Dependencies**: #{circular.any? ? circular.map { |c| c.join(' ↔ ') }.join(', ') : 'None detected'}
          - **Aggregate Boundary Violations**: #{aggregate_violations.any? ? aggregate_violations.map(&:name).join(', ') : 'None detected'}
          - **Transaction Boundary Issues**: #{transaction_violations.any? ? transaction_violations.map(&:name).join(', ') : 'None detected'}
          
          ## Your Task:
          Based on the dependency clusters and architectural violations detected, propose a high-level DDD refactoring plan.
        PROMPT

        prompt
      end
    end
  end
end
