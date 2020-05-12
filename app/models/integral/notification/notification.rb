module Integral
  module Notification
    class Notification < ApplicationRecord
      belongs_to :recipient, class_name: "User"
      belongs_to :actor, class_name: "User", optional: true
      belongs_to :subscribable, polymorphic: true

      scope :unread, ->{ where(read_at: nil) }
      scope :recent, ->{ order(created_at: :desc).limit(per_page) }

      self.per_page = 8

      def read!
        update!(read_at: Time.now())
      end

      def unread?
        read_at.nil?
      end

      def to_partial_path
        'integral/backend/notifications/notification'
      end
    end
  end
end
