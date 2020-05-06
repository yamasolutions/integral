module Integral
  module Notification
    class Subscription < ApplicationRecord
      self.table_name = 'integral_notification_subscriptions'

      belongs_to :subscribable, polymorphic: true, optional: true
      belongs_to :user

      validates :subscribable_type, :state, presence: true

      # TODO: Change state to enum? Get these and much more for free
      def subscribed?
        state == 'subscribed'
      end

      def unsubscribed?
        state == 'unsubscribed'
      end
    end
  end
end
