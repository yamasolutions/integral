module Integral
  module Webhook
    class Event
      attr_reader :event_name, :payload

      def initialize(event_name, payload = {})
        @event_name = event_name
        @payload = payload
      end

      def as_json(*args)
        payload[:event_name] = event_name
        payload
      end
    end
  end
end
