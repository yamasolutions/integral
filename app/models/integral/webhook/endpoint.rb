module Integral
  module Webhook
    class Endpoint < ApplicationRecord
      self.table_name = "integral_webhook_endpoints"

      attribute :events, :string, array: true, default: []

      validates :target_url,
        presence: true,
        format: URI.regexp(%w(http https))

      validates :events,
        presence: true

      def self.for_event(events)
        where('events @> ARRAY[?]::varchar[]', Array(events))
      end

      def events=(events)
        events = Array(events).map { |event| event.to_s.underscore }
        # TODO: Validate events from specified list in Integral.config which can be used to list them on the backend for click and create
        # super(Webhook::Event::EVENT_TYPES & events)
        super(events)
      end

      def deliver(event)
        Webhook::DeliveryJob.perform_later(id, event.to_json)
      end
    end
  end
end
