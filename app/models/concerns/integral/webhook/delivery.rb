module Integral
  module Webhook
    module Delivery
      extend ActiveSupport::Concern

      def webhook_payload
        {}
      end

      def deliver_webhook(action)
        event_name = "#{self.class.name.underscore}_#{action}"
        deliver_webhook_event(event_name, webhook_payload)
      end

      def deliver_webhook_event(event_name, payload)
        event = Webhook::Event.new(event_name, payload || {})

        Endpoint.for_event(event_name).each do |endpoint|
          endpoint.deliver(event)
        end
      end
    end
  end
end
