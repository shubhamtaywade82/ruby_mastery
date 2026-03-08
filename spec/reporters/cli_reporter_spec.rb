# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/ruby_mastery/reporters/cli_reporter"
require_relative "../../lib/ruby_mastery/rules/base_rule"

RSpec.describe RubyMastery::Reporters::CliReporter do
  it "renders table without errors" do
    violation = RubyMastery::Rules::BaseRule::Violation.new(
      rule: "TestRule",
      file: "test.rb",
      line: 1,
      message: "Example violation",
      suggestion: "Fix it"
    )

    reporter = described_class.new([violation])

    expect { reporter.render }.not_to raise_error
  end
end
