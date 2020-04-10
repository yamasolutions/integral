module Integral
  module Notification
    class Subscription < ApplicationRecord
      self.table_name = 'integral_notification_subscriptions'

      belongs_to :subscribable, polymorphic: true, optional: true
      belongs_to :user

      validates :subscribable_type, :state, presence: true
    end
  end
end
