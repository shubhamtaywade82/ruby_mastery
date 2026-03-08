# frozen_string_literal: true

module RubyMastery
  module Architecture
    module Graph
      class Node
        attr_reader :name, :type

        def initialize(name, type)
          @name = name
          @type = type
        end

        def to_s
          "#{type}:#{name}"
        end

        def hash
          [name, type].hash
        end

        def ==(other)
          self.class == other.class && name == other.name && type == other.type
        end
        alias_method :eql?, :==
      end
    end
  end
end
