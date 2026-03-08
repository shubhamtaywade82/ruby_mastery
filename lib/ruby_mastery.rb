# frozen_string_literal: true
require "parser/current"
require "json"

require_relative "ruby_mastery/cli"
require_relative "ruby_mastery/engine/analyzer_engine"
require_relative "ruby_mastery/engine/refactor_engine"
require_relative "ruby_mastery/reporters/cli_reporter"
require_relative "ruby_mastery/reporters/json_reporter"
require_relative "ruby_mastery/reporters/markdown_reporter"

module RubyMastery
  VERSION = "0.2.0"
  class Error < StandardError; end

  def self.analyze(path)
    Engine::AnalyzerEngine.new(path).run
  end

  def self.refactor(path)
    Engine::RefactorEngine.new(path).run
  end

  def self.report(path, format: :cli)
    violations = analyze(path)

    case format.to_sym
    when :json
      Reporters::JsonReporter.new(violations).render
    when :markdown
      Reporters::MarkdownReporter.new(violations).render
    else
      Reporters::CliReporter.new(violations).render
    end
  end
end
