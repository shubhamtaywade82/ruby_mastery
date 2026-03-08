# frozen_string_literal: true
require "tty-table"

module RubyMastery
  module Reporters
    class CliReporter
      def initialize(violations)
        @violations = violations
      end

      def render
        if @violations.empty?
          puts "No violations found! Your Ruby is masterfully written."
          return
        end

        rows = @violations.map do |v|
          [v.file, v.rule, v.line, v.message, v.suggestion]
        end

        table = TTY::Table.new(
          ["File", "Rule", "Line", "Message", "Suggestion"],
          rows
        )
        puts table.render(:ascii)
        puts "\nTotal Violations: #{@violations.size}"
      end
    end
  end
end
