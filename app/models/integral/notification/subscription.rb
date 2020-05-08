module Integral
  module Notification
    class Subscription < ApplicationRecord
      self.table_name = 'integral_notification_subscriptions'

      belongs_to :subscribable, polymorphic: true, optional: true
      belongs_to :user

      enum state: { subscribed: 'subscribed', unsubscribed: 'unsubscribed' }

      validates :subscribable_type, :state, presence: true
    end
  end
end
