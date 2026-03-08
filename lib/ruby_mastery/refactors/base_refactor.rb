# frozen_string_literal: true

require "parser/current"

module RubyMastery
  module Refactors
    class BaseRefactor
      def initialize(file_path)
        @file_path = file_path
      end

      def apply
        source = File.read(@file_path)
        new_source = transform(source)
        
        File.write(@file_path, new_source) if new_source != source
      end

      protected

      def transform(source)
        raise NotImplementedError, "#{self.class} must implement #transform"
      end

      def parse(source)
        parser = Parser::CurrentRuby.new
        buffer = Parser::Source::Buffer.new(@file_path)
        buffer.source = source
        ast = parser.parse(buffer)
        [buffer, ast]
      end
    end
  end
end
