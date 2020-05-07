module Integral
  module Notification
    module Subscribable
      extend ActiveSupport::Concern

      included do
        attr_accessor :integral_notification_action

        has_many :notification_subscriptions, as: :subscribable, class_name: "Integral::Notification::Subscription"

          after_commit on: :create do
            create_notifications(:create)
          end

          after_commit on: :update do
            create_notifications(:update)
          end

          after_commit on: :destroy do
            create_notifications(:destroy)
          end
      end

      class_methods do
        def notification_subscriptions(omit_users:)
          Integral::Notification::Subscription.where(subscribable: self).where.not(user_id: omit_users)
        end

        def subscribable?
          true
        end
      end

      def subscribable?
        true
      end

      def notifiable_users
        object_notification_subscriptions = notification_subscriptions.group_by(&:state)
        object_notification_subscription_user_ids = object_notification_subscriptions.values.flatten.map(&:user_id)

        class_notification_subscriptions = self.class.notification_subscriptions(omit_users: object_notification_subscription_user_ids).group_by(&:state)
        class_notification_subscription_user_ids = class_notification_subscriptions.values.flatten.map(&:user_id)

        top_level_notification_subscription_user_ids = Integral::User.where(notify_me: true).where.not(id: object_notification_subscription_user_ids + class_notification_subscription_user_ids).pluck(:id)

        notifiable_user_ids = (object_notification_subscriptions['subscribe']&.map(&:user_id) || []) + (class_notification_subscriptions['subscribe']&.map(&:user_id) || []) + top_level_notification_subscription_user_ids
        notifiable_user_ids -= [PaperTrail.request.whodunnit]

        User.find(notifiable_user_ids).select { |user| Pundit.policy!(user, self).receives_notifications? }
      end

      private

      # TODO Improvements:
      # - Move into a Job - Pass through the created_at time otherwise the notification sets it when the notifcation was created, rather than when the action was committed
      # - Anyway to create multiple in one go but still run callbacks?
      def create_notifications(action)
        if PaperTrail.request.whodunnit
          notifiable_users.each do |notifiable|
            Integral::Notification::Notification.create!(subscribable: self, recipient: notifiable, action: (integral_notification_action || action), actor_id: PaperTrail.request.whodunnit)
          end
        end
      end
    end
  end
end
