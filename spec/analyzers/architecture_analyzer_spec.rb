# frozen_string_literal: true
require "parser/current"
require_relative "../../lib/ruby_mastery/analyzers/architecture_analyzer"

RSpec.describe RubyMastery::Analyzers::ArchitectureAnalyzer do
  def analyze(code)
    buffer = Parser::Source::Buffer.new("(test)")
    buffer.source = code

    parser = Parser::CurrentRuby.new
    ast = parser.parse(buffer)

    described_class.new("test.rb", ast).analyze
  end

  it "detects procedural class" do
    code = <<~RUBY
      class Calculator
        def self.add(a,b)
          a+b
        end
      end
    RUBY

    violations = analyze(code)
    expect(violations.first.message).to match(/Procedural class/)
  end
end
