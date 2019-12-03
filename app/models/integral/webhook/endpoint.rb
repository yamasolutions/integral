module Integral
  # Webhook Implementation - https://benediktdeicke.com/2017/09/sending-webhooks-with-rails/
  module Webhook
    # A Webhook::Endpoint can listen to one or more Webhook::Event, everytime an Event is created
    # it is sent (along with its payload) to the Endpoint target_url
    class Endpoint < ApplicationRecord
      self.table_name = 'integral_webhook_endpoints'

      attribute :events, :string, array: true, default: []

      validates :target_url,
                presence: true,
                format: URI.regexp(%w[http https])

      validates :events,
                presence: true

      # @param events [Array] list of Integral::Webhook::Event names
      #
      # @return [Integral::Webhook::Endpoint] endpoints which are listening for the provided events
      def self.for_event(events)
        where('events @> ARRAY[?]::varchar[]', Array(events))
      end

      # Override the default setter to normalise the events and validate them (TODO)
      def events=(events)
        events = Array(events).map { |event| event.to_s.underscore }
        # TODO: Validate events from specified list in Integral.config which can be used to
        # list them on the backend for click and create
        # super(Webhook::Event::EVENT_TYPES & events)
        super(events)
      end

      # Deliver a particular event to the endpoint
      def deliver(event)
        Webhook::DeliveryJob.perform_later(id, event.to_json)
      end
    end
  end
end
