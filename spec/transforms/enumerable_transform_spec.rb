# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/ruby_mastery/transforms/enumerable_transform"

RSpec.describe RubyMastery::Transforms::EnumerableTransform do
  def transform(code)
    buffer = Parser::Source::Buffer.new("(test)")
    buffer.source = code
    ast = Parser::CurrentRuby.new.parse(buffer)
    described_class.new(buffer).rewrite(ast).process
  end

  it "converts for loop to each" do
    code = <<~RUBY
      for x in items
        puts x
      end
    RUBY

    result = transform(code)
    expect(result).to include("items.each")
  end
end
