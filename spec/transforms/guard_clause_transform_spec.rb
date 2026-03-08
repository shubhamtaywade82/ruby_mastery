# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/ruby_mastery/transforms/guard_clause_transform"

RSpec.describe RubyMastery::Transforms::GuardClauseTransform do
  def transform(code)
    buffer = Parser::Source::Buffer.new("(test)")
    buffer.source = code
    ast = Parser::CurrentRuby.new.parse(buffer)
    described_class.new(buffer).rewrite(ast).process
  end

  it "adds guard clause" do
    code = <<~RUBY
      if !valid
        return
      end
    RUBY

    result = transform(code)
    expect(result).to include("return if !valid")
  end
end
