# frozen_string_literal: true
module RubyMastery
  module Reporters
    class MarkdownReporter
      def initialize(violations)
        @violations = violations
      end

      def render
        lines = ["# Ruby Mastery Report", ""]
        if @violations.empty?
          lines << "No violations found!"
        else
          @violations.each do |v|
            lines << "- **#{v.file}:#{v.line}** [#{v.rule}] — #{v.message} (Suggestion: #{v.suggestion})"
          end
        end
        puts lines.join("\n")
      end
    end
  end
end
