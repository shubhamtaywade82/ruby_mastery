# frozen_string_literal: true
require "parser/current"
require_relative "../../lib/ruby_mastery/analyzers/ast_analyzer"

RSpec.describe RubyMastery::Analyzers::AstAnalyzer do
  def analyze(code)
    buffer = Parser::Source::Buffer.new("(test)")
    buffer.source = code

    parser = Parser::CurrentRuby.new
    ast = parser.parse(buffer)

    described_class.new("test.rb", ast).analyze
  end

  context "when method is too long" do
    it "detects violation" do
      code = <<~RUBY
        def example
          a=1
          b=2
          c=3
          d=4
          e=5
          f=6
          g=7
          h=8
          i=9
          j=10
          k=11
        end
      RUBY

      violations = analyze(code)
      expect(violations.any? { |v| v.message =~ /Method too long/ }).to be(true)
    end
  end

  context "when nested conditionals exist" do
    it "detects deep nesting" do
      code = <<~RUBY
        def test
          if a
            if b
              if c
                puts c
              end
            end
          end
        end
      RUBY

      violations = analyze(code)
      expect(violations.any? { |v| v.message =~ /Deep nesting/ }).to be(true)
    end
  end
end
