# frozen_string_literal: true

require "spec_helper"
require_relative "../../../lib/ruby_mastery/architecture/scoring/domain_score_calculator"

RSpec.describe RubyMastery::Architecture::Scoring::DomainScoreCalculator do
  describe "#score" do
    it "returns 100 for zero metrics" do
      metrics = {
        anemic_models: 0,
        god_models: 0,
        callback_abuse: 0,
        service_misuse: 0,
        circular_dependencies: 0,
        transaction_boundary_violations: 0
      }
      calculator = described_class.new(metrics)
      expect(calculator.score).to eq(100)
    end

    it "applies penalties correctly" do
      metrics = {
        anemic_models: 2, # -6
        god_models: 1,   # -5
        circular_dependencies: 1 # -10
      }
      calculator = described_class.new(metrics)
      expect(calculator.score).to eq(79)
    end

    it "does not return a negative score" do
      metrics = {
        circular_dependencies: 20 # -200
      }
      calculator = described_class.new(metrics)
      expect(calculator.score).to eq(0)
    end
  end
end
