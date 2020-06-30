module Integral
  module Backend
    class NotificationSubscriptionsController < BaseController
      def update
        subscription = current_user.own_notification_subscriptions.find_or_initialize_by(resource_params.except('state'))
        subscription.state = resource_params['state']

        if subscription.save
          head :ok
        else
          head :unprocessable_entity
        end
      end

      private

      def resource_params
        # Must be nicer way to do this, just want to switch out empty subscribable_id for nil
        params[:subscription].permit(:state, :subscribable_type, :subscribable_id).to_h.inject({}) { |h, (k, v)| k == 'subscribable_id' && v =='' ? h[k] = nil : h[k] = v; h }
      end
    end
  end
end
