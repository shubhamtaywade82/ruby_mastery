# frozen_string_literal: true
require "json"
require "find"
require "parser/current"

require_relative "../architecture/graph_builder"
require_relative "../architecture/analyzers/anemic_model_analyzer"
require_relative "../architecture/analyzers/service_object_analyzer"

module RubyMastery
  module Agent
    class ContextGenerator
      def self.generate(path)
        puts "==> Building Project-Wide AST Graph..."
        
        ruby_files = if File.directory?(path)
                       Find.find(path).select { |f| f.end_with?(".rb") }
                     else
                       [path]
                     end

        graph_dependencies = {}
        architecture_violations = []

        ruby_files.each do |file|
          begin
            buffer = Parser::Source::Buffer.new(file)
            buffer.source = File.read(file)
            ast = Parser::CurrentRuby.new.parse(buffer)
            next unless ast

            # 1. Build Graph
            graph = Architecture::GraphBuilder.new(ast)
            graph.dependencies.each do |class_name, deps|
              graph_dependencies[class_name] ||= []
              graph_dependencies[class_name].concat(deps).uniq!
            end

            # 2. Run Architectural Analyzers
            anemic_analyzer = Architecture::Analyzers::AnemicModelAnalyzer.new(file, ast)
            architecture_violations.concat(anemic_analyzer.violations)

            service_analyzer = Architecture::Analyzers::ServiceObjectAnalyzer.new(file, ast)
            architecture_violations.concat(service_analyzer.violations)
          rescue StandardError => e
            # Skip unparseable files
          end
        end

        prompt = <<~PROMPT
          # System Architect AI Context
          
          You are a Senior Ruby Architect Agent. Below is the structural state of the requested Rails repository.
          
          ## 1. Class Dependency Graph
          This graph maps which classes reference which other constants. Look for cyclic dependencies or Domain Boundary violations (e.g. Billing module calling Shipping internal models directly).
          
          ```json
          #{JSON.pretty_generate(graph_dependencies)}
          ```
          
          ## 2. Architectural Violations Detected
          The static analysis engine has flagged the following Domain-Driven Design and Rails architectural anti-patterns:
          
          ```json
          #{JSON.pretty_generate(architecture_violations)}
          ```
          
          ## Your Task:
          Based on the dependency graph and the anemic/service-object anti-patterns above, propose a high-level DDD refactoring plan. Identify domain boundaries that should be extracted into modules, and Models that need to reclaim their business logic.
        PROMPT

        prompt
      end
    end
  end
end
