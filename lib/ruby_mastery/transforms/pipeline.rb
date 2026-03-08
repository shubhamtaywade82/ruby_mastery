# frozen_string_literal: true
require "parser/current"
require_relative "enumerable_transform"
require_relative "guard_clause_transform"
require_relative "boolean_flag_transform"
require_relative "method_extraction_transform"

module RubyMastery
  module Transforms
    class Pipeline
      TRANSFORMS = [
        EnumerableTransform,
        GuardClauseTransform,
        BooleanFlagTransform,
        MethodExtractionTransform
      ]

      def self.apply(code)
        buffer = Parser::Source::Buffer.new("(source)")
        buffer.source = code

        ast = Parser::CurrentRuby.new.parse(buffer)

        return code unless ast

        TRANSFORMS.each do |transform|
          rewriter = transform.new(buffer).rewrite(ast)
          code = rewriter.process

          buffer = Parser::Source::Buffer.new("(source)")
          buffer.source = code
          ast = Parser::CurrentRuby.new.parse(buffer)
        end

        code
      end
    end
  end
end
