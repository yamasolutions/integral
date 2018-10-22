module Integral
  module ChartRenderer
    # http://www.chartjs.org/samples/latest/charts/doughnut.html
    class Donut < Base
      private

      def respond_with_chart(data)
        locals = {
          data: data,
          dataset: @dataset
        }
        render_partial('donut', locals)
      end

      # Line will fail if no 'period' option is supplied throw wrong argument error or w.e
      def process_data
        @dataset.map { |item| item[:scope].count }
      end
    end
  end
end
