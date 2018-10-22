module Integral
  # Renders chart markup to be used with ChartJS
  # http://www.chartjs.org/
  #
  # TODO: How to handle caching?
  module ChartRenderer
    # Base class which all Charts should inherit from
    class Base
      # Render chart markup
      def self.render(dataset, options = {})
        renderer = new(dataset, options)
        renderer.render
      end

      # @param [Hash] dataset
      # @param [Hash] options
      def initialize(dataset, options = {})
        @dataset = dataset
        @options = options
      end

      # Render chart markup
      def render
        data = process_data

        return respond_with_chart(data) if data_available?(data)
        respond_with_no_data_available
      end

      private

      # @return [String] Markup which frontend uses to build a graph
      def respond_with_chart(_data)
        raise NotImplementedError
      end

      # Process data values from provided dataset to be converted into graph markup
      def process_data
        raise NotImplementedError
      end

      # Controller used to render partials
      def controller
        ApplicationController
      end

      # Renders a given partial
      #
      # @param [String] path partial path to render
      # @param [Hash] locals optional hash of variables to pass to partial
      #
      # @return [String] Markup which frontend uses to build a graph
      def render_partial(path, locals = {})
        controller.render(partial: "integral/backend/shared/graphs/#{path}",
                          locals: locals,
                          layout: false)
      end

      # @return [Boolean] whether or not any data is present
      def data_available?(data)
        return false if data.empty?

        if data.first.is_a?(Array)
          data = data.map(&:uniq).uniq

          return true if data.length > 1
          data = data.first
        end

        data = data.uniq
        !(data.length == 1 && data.first.zero?)
      end

      # @return [String] Markup which informs users of no available data to build graph
      def respond_with_no_data_available
        render_partial('no_data_available')
      end
    end
  end
end
