# frozen_string_literal: true
require_relative "base_rule"

module RubyMastery
  module Rules
    class ObjectModelRules < BaseRule
      def procedural_class(line)
        violation(
          line: line,
          message: "Procedural class detected",
          suggestion: "Use instance methods or modules"
        )
      end

      def fat_controller(line)
        violation(
          line: line,
          message: "Fat controller detected",
          suggestion: "Move logic into models or domain objects"
        )
      end
    end
  end
end
