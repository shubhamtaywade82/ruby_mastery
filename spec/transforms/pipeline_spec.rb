# frozen_string_literal: true
require "parser/current"
require_relative "../../lib/ruby_mastery/transforms/pipeline"

RSpec.describe RubyMastery::Transforms::Pipeline do
  describe ".apply" do
    it "converts for loop to each" do
      code = <<~RUBY
        for x in items
          puts x
        end
      RUBY

      result = described_class.apply(code)
      expect(result).to include("items.each")
    end

    it "adds guard clause" do
      code = <<~RUBY
        if !valid
          return
        end
      RUBY

      result = described_class.apply(code)
      expect(result).to include("return if !valid")
    end
  end
end
