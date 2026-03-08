# frozen_string_literal: true
require_relative "../transforms/pipeline"

module RubyMastery
  module Engine
    class RefactorEngine
      attr_reader :path

      def initialize(path)
        @path = path
      end

      def run
        files.each do |file|
          apply_refactors(file)
        end
      end

      private

      def files
        if File.directory?(path)
          Dir.glob("#{path}/**/*.rb")
        else
          [path]
        end
      end

      def apply_refactors(file)
        code = File.read(file)
        code = RubyMastery::Transforms::Pipeline.apply(code)
        File.write(file, code)
      rescue StandardError => e
        warn "Refactor failed for #{file}: #{e.message}"
      end
    end
  end
end
