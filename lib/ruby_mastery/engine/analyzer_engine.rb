# frozen_string_literal: true
require "find"
require "parser/current"
require "json"
require "open3"

require_relative "../analyzers/ast_analyzer"
require_relative "../analyzers/ruby_idiom_analyzer"
require_relative "../analyzers/architecture_analyzer"
require_relative "../analyzers/rails_analyzer"
require_relative "../analyzers/rails_domain_analyzer"
require_relative "../analyzers/service_object_analyzer"
require_relative "../analyzers/rails_controller_query_analyzer"
require_relative "../analyzers/rubocop_analyzer"
require_relative "../analyzers/solid_analyzer"
require_relative "../analyzers/clean_code_analyzer"
require_relative "../analyzers/ruby_modernizer"
require_relative "../analyzers/design_pattern_analyzer"

module RubyMastery
  module Engine
    class AnalyzerEngine
      attr_reader :path

      def initialize(path)
        @path = path
        @rubocop_offenses_map = {}
      end

      def run
        run_rubocop_globally
        
        ruby_files.flat_map do |file|
          analyze_file(file)
        end
      end

      private

      def run_rubocop_globally
        stdout, _stderr, _status = Open3.capture3("bundle exec rubocop --format json --force-exclusion #{path}")
        return if stdout.empty?
        data = JSON.parse(stdout)
        data['files']&.each { |f| @rubocop_offenses_map[f['path']] = f['offenses'] }
      rescue StandardError; end

      def ruby_files
        File.directory?(path) ? Find.find(path).select { |f| f.end_with?(".rb") } : [path]
      end

      def analyze_file(file)
        buffer = Parser::Source::Buffer.new(file)
        buffer.source = File.read(file)
        ast = Parser::CurrentRuby.new.parse(buffer)
        return [] unless ast

        analyzers.flat_map do |analyzer_class|
          puts "DEBUG: Running analyzer: #{analyzer_class} for #{file}"
          if analyzer_class == RubyMastery::Analyzers::RubocopAnalyzer
            offenses = find_offenses_for(file)
            analyzer_class.new(file, ast, offenses).analyze
          else
            analyzer_class.new(file, ast).analyze
          end
        end
      rescue StandardError => e
        warn "Failed analyzing #{file}: #{e.message}"
        []
      end

      def find_offenses_for(file)
        @rubocop_offenses_map[file] || @rubocop_offenses_map[File.expand_path(file)] || []
      end

      def analyzers
        [
          RubyMastery::Analyzers::AstAnalyzer,
          RubyMastery::Analyzers::RubyIdiomAnalyzer,
          RubyMastery::Analyzers::ArchitectureAnalyzer,
          RubyMastery::Analyzers::RailsAnalyzer,
          RubyMastery::Analyzers::RailsDomainAnalyzer,
          RubyMastery::Analyzers::ServiceObjectAnalyzer,
          RubyMastery::Analyzers::ControllerQueryAnalyzer,
          RubyMastery::Analyzers::RubocopAnalyzer,
          RubyMastery::Analyzers::SolidAnalyzer,
          RubyMastery::Analyzers::CleanCodeAnalyzer,
          RubyMastery::Analyzers::RubyModernizer,
          RubyMastery::Analyzers::DesignPatternAnalyzer
        ]
      end
    end
  end
end
