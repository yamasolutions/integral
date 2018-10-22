module Integral
  module ChartRenderer
    # http://www.chartjs.org/samples/latest/charts/line.html
    class Line < Base
      private

      def respond_with_chart(data)
        labels = (1..7).collect { |i| (Date.today - i.day).strftime('%a') }.join(',')
        locals = {
          data: data,
          dataset: @dataset,
          labels: labels
        }
        render_partial('line', locals)
      end

      # Line will fail if no 'period' option is supplied throw wrong argument error or w.e
      def process_data
        raw_data = @dataset.map { |item| item[:scope].group_by_day(:created_at, last: 7, current: false).count }
        raw_data.map(&:values)
      end
    end
  end
end
