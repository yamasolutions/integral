require 'net/http'

module Integral
  module Webhook
    # Handles the delivery of a webhook event payload to a webhook endpoint
    class DeliveryJob < ApplicationJob
      # Delivers webhook payload to endpoint
      def perform(endpoint_id, payload)
        return unless endpoint = Webhook::Endpoint.find(endpoint_id)

        response = request(endpoint.target_url, payload)

        case response.code
        when 410
          endpoint.destroy
        when 400..599
          raise response.to_s
        end
      end

      private

      def request(endpoint, payload)
        uri = URI.parse(endpoint)

        request = Net::HTTP::Post.new(uri.request_uri)
        request['Content-Type'] = 'application/json'
        request.body = payload

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')

        http.request(request)
      end
    end
  end
end
