# frozen_string_literal: true
require "json"

module RubyMastery
  module Reporters
    class JsonReporter
      def initialize(violations)
        @violations = violations
      end

      def render
        puts JSON.pretty_generate(@violations.map(&:to_h))
      end
    end
  end
end
