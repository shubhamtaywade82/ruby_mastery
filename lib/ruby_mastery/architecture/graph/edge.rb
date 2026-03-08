# frozen_string_literal: true

module RubyMastery
  module Architecture
    module Graph
      class Edge
        attr_reader :from, :to, :type

        def initialize(from:, to:, type:)
          @from = from
          @to = to
          @type = type
        end
      end
    end
  end
end
