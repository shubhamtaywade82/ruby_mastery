# frozen_string_literal: true
require_relative "base_rule"

module RubyMastery
  module Rules
    class MethodRules < BaseRule
      def max_method_length
        10
      end

      def long_method(line)
        violation(
          line: line,
          message: "Method too long",
          suggestion: "Split method into smaller methods"
        )
      end

      def deep_nesting(line)
        violation(
          line: line,
          message: "Deep nesting detected",
          suggestion: "Introduce guard clauses"
        )
      end

      def procedural_loop(line)
        violation(
          line: line,
          message: "Procedural loop detected",
          suggestion: "Use Ruby enumerables"
        )
      end

      def idiom_violation(line, message, suggestion)
        violation(
          line: line,
          message: message,
          suggestion: suggestion
        )
      end

      def temporary_variable(line)
        violation(
          line: line,
          message: "Temporary variable detected",
          suggestion: "Use tap or method chaining"
        )
      end

      def large_class(line)
        violation(
          line: line,
          message: "Class too large",
          suggestion: "Extract responsibilities"
        )
      end
    end
  end
end
