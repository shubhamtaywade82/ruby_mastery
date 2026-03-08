# frozen_string_literal: true
module RubyMastery
  module Rules
    class BaseRule
      Violation = Struct.new(
        :rule,
        :file,
        :line,
        :message,
        :suggestion,
        keyword_init: true
      )

      attr_reader :file, :config

      def initialize(file, config = {})
        @file = file
        @config = config
      end

      def violation(line:, message:, suggestion: nil)
        Violation.new(
          rule: self.class.name.split("::").last,
          file: file,
          line: line,
          message: message,
          suggestion: suggestion
        )
      end
    end
  end
end
