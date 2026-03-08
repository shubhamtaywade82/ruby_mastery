# frozen_string_literal: true
require "thor"

module RubyMastery
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
    end
    end
