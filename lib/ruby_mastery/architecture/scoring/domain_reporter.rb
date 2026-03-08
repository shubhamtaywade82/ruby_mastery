module RubyMastery
  module Architecture
    module Scoring
      class DomainReporter
        def initialize(score, metrics)
          @score = score
          @metrics = metrics
        end

        def render
          puts "Rails Domain Architecture Health"
          puts "--------------------------------"
          puts "Score: #{@score}/100"
          puts

          @metrics.each do |metric, value|
            puts "#{metric}: #{value}"
          end
        end
      end
    end
  end
end
