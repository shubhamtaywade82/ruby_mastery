# frozen_string_literal: true
require "parser/current"
require_relative "../../lib/ruby_mastery/analyzers/ruby_idiom_analyzer"

RSpec.describe RubyMastery::Analyzers::RubyIdiomAnalyzer do
  def analyze(code)
    buffer = Parser::Source::Buffer.new("(test)")
    buffer.source = code

    parser = Parser::CurrentRuby.new
    ast = parser.parse(buffer)

    described_class.new("test.rb", ast).analyze
  end

  it "detects for loops" do
    code = <<~RUBY
      for i in [1,2,3]
        puts i
      end
    RUBY

    violations = analyze(code)
    expect(violations.first.message).to match(/Avoid for-loops/)
  end
end
