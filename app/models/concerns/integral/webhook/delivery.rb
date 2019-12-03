module Integral
  module Webhook
    # Helper to handle the delivery of webhook events
    module Delivery
      extend ActiveSupport::Concern

      # Abstract method to be overriden
      #
      # @return [Hash] which repesents the object
      def webhook_payload
        {}
      end

      # Build event_name and delivery webhook
      def deliver_webhook(action)
        event_name = "#{self.class.name.underscore}_#{action}"
        deliver_webhook_event(event_name, webhook_payload)
      end

      # Create webhook event and deliver it to any endpoint listening
      def deliver_webhook_event(event_name, payload)
        event = Webhook::Event.new(event_name, payload || {})

        Endpoint.for_event(event_name).each do |endpoint|
          endpoint.deliver(event)
        end
      end
    end
  end
end
