module RubyMastery
  module Architecture
    module Scoring
      class DomainScoreCalculator
        MAX_SCORE = 100

        def initialize(report)
          @report = report
        end

        def score
          [0, MAX_SCORE - penalties].max
        end

        private

        def penalties
          penalty(:anemic_models, 3) +
          penalty(:god_models, 5) +
          penalty(:callback_abuse, 4) +
          penalty(:service_misuse, 5) +
          penalty(:circular_dependencies, 10) +
          penalty(:transaction_boundary_violations, 8)
        end

        def penalty(metric, weight)
          (@report[metric] || 0) * weight
        end
      end
    end
  end
end
