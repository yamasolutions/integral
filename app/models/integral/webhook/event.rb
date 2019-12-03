module Integral
  # Webhook Implementation source from - https://benediktdeicke.com/2017/09/sending-webhooks-with-rails/
  module Webhook
    # An event instance which a Webhook::Endpoint might be listening too, for example a post publication, creation or deletion
    class Event
      attr_reader :event_name, :payload

      def initialize(event_name, payload = {})
        @event_name = event_name
        @payload = payload
      end

      # Adds the event_name to the JSON representation
      def as_json(*_args)
        payload[:event_name] = event_name
        payload
      end
    end
  end
end
