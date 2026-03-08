# frozen_string_literal: true
require "thor"

module RubyMastery
  class ArchitectureCommand < Thor
    desc "graph PATH", "Generate architecture graph (GraphViz DOT)"
    def graph(path)
      require_relative "architecture/graph/graph"
      require_relative "architecture/builders/controller_graph_builder"
      require_relative "architecture/builders/model_graph_builder"
      require_relative "architecture/builders/service_graph_builder"
      require_relative "architecture/visualizer/graphviz_exporter"
      require_relative "architecture/visualizer/architecture_renderer"

      graph = RubyMastery::Architecture::Graph::Graph.new
      # In a real scenario, we would parse files and build the graph.
      # For now, let's just create a dummy graph to show it works.
      
      # Mock building logic
      renderer = RubyMastery::Architecture::Visualizer::ArchitectureRenderer.new(graph)
      renderer.render
    end

    desc "score PATH", "Calculate architecture health score"
    def score(path)
      require_relative "architecture/scoring/domain_score_calculator"
      require_relative "architecture/scoring/domain_reporter"

      # In a real scenario, we would run analyzers.
      # Mock metrics
      metrics = {
        anemic_models: 0,
        god_models: 0,
        callback_abuse: 0,
        service_misuse: 0,
        circular_dependencies: 0,
        transaction_boundary_violations: 0
      }
      
      calculator = RubyMastery::Architecture::Scoring::DomainScoreCalculator.new(metrics)
      score = calculator.score
      
      RubyMastery::Architecture::Scoring::DomainReporter.new(score, metrics).render
    end
  end

  class CLI < Thor
    desc "analyze PATH", "Analyze Ruby codebase"
    def analyze(path)
      violations = RubyMastery.analyze(path)
      Reporters::CliReporter.new(violations).render
    end

    desc "refactor PATH", "Apply automated refactors"
    def refactor(path)
      RubyMastery.refactor(path)
      puts "Refactor complete"
    end

    desc "report PATH", "Generate report"
    method_option :format, aliases: "-f", default: "cli"
    def report(path)
      format = options[:format].to_sym
      output = RubyMastery.report(path, format: format)
      puts output if format == :json || format == :markdown
    end

    desc "architect PATH", "Generate AI Context for Project Architecture"
    def architect(path)
      require_relative "agent/context_generator"
      puts RubyMastery::Agent::ContextGenerator.generate(path)
    end

    desc "architecture COMMAND", "Architecture monitoring system"
    subcommand "architecture", ArchitectureCommand
  end
end
