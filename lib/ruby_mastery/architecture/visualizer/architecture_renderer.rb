module RubyMastery
  module Architecture
    module Visualizer
      class ArchitectureRenderer
        def initialize(graph)
          @graph = graph
        end

        def render(output: "architecture.dot")
          exporter = GraphvizExporter.new(@graph)
          dot = exporter.export

          File.write(output, dot)

          puts "Graph written to #{output}"
        end
      end
    end
  end
end
