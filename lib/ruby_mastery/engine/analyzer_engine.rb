# frozen_string_literal: true
require "find"
require "parser/current"

require_relative "../analyzers/ast_analyzer"
require_relative "../analyzers/ruby_idiom_analyzer"
require_relative "../analyzers/architecture_analyzer"
require_relative "../analyzers/rails_analyzer"
require_relative "../analyzers/rails_domain_analyzer"
require_relative "../analyzers/service_object_analyzer"
require_relative "../analyzers/rails_controller_query_analyzer"

module RubyMastery
  module Engine
    class AnalyzerEngine
      attr_reader :path

      def initialize(path)
        @path = path
      end

      def run
        ruby_files.flat_map do |file|
          analyze_file(file)
        end
      end

      private

      def ruby_files
        if File.directory?(path)
          Find.find(path).select { |f| f.end_with?(".rb") }
        else
          [path]
        end
      end

      def analyze_file(file)
        buffer = Parser::Source::Buffer.new(file)
        buffer.source = File.read(file)

        parser = Parser::CurrentRuby.new
        ast = parser.parse(buffer)

        return [] unless ast

        analyzers.flat_map do |analyzer|
          analyzer.new(file, ast).analyze
        end
      rescue StandardError => e
        warn "Failed analyzing #{file}: #{e.message}"
        []
      end

      def analyzers
        [
          RubyMastery::Analyzers::AstAnalyzer,
          RubyMastery::Analyzers::RubyIdiomAnalyzer,
          RubyMastery::Analyzers::ArchitectureAnalyzer,
          RubyMastery::Analyzers::RailsAnalyzer,
          RubyMastery::Analyzers::RailsDomainAnalyzer,
          RubyMastery::Analyzers::ServiceObjectAnalyzer,
          RubyMastery::Analyzers::ControllerQueryAnalyzer
        ]
      end
    end
  end
end
