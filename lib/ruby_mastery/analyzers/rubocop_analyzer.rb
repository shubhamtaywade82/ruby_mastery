# frozen_string_literal: true
require "json"
require "open3"

module RubyMastery
  module Analyzers
    class RubocopAnalyzer
      attr_reader :file, :violations

      def initialize(file, ast = nil, rubocop_offenses = [])
        @file = file
        @violations = []
        @rubocop_offenses = rubocop_offenses
      end

      def analyze
        @rubocop_offenses.each do |offense|
          @violations << RubyMastery::Rules::BaseRule::Violation.new(
            rule: "RuboCop:#{offense['cop_name']}",
            file: file,
            line: offense['location']['start_line'],
            message: offense['message'],
            suggestion: offense['correctable'] ? "Auto-correct available (--fix)" : nil
          )
        end
        @violations
      end
    end
  end
end
