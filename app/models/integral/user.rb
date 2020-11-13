module Integral
  # User model used to represent a authenticated user
  class User < ApplicationRecord
    acts_as_paranoid # Soft-deletion
    acts_as_integral({
      backend_main_menu: { order: 60 },
      backend_create_menu: { order: 50 }
    }) # Integral Goodness

    mount_uploader :avatar, AvatarUploader
    process_in_background :avatar

    # Included devise modules. Others available are:
    # :confirmable, :timeoutable, :omniauthable, registerable and lockable
    devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

    enum status: %i[pending active blocked]

    # Relations
    has_many :role_assignments
    has_many :roles, through: :role_assignments
    # notification_subscription is used by Subscribable concern - Users can have notification_subscriptions AND be subscribable
    has_many :own_notification_subscriptions, class_name: "Integral::Notification::Subscription"
    has_many :notifications, class_name: "Integral::Notification::Notification", foreign_key: :recipient_id

    # Validations
    validates :name, :email, presence: true
    validates :name, length: { minimum: 3, maximum: 25 }

    has_paper_trail versions: { class_name: 'Integral::UserVersion' }

    scope :search, ->(search) { where('lower(name) LIKE ?', "%#{search.downcase}%") }

    # Checks if the User has a given role
    #
    # @param role_sym [Symbol] role(s) to check - Can be array of symbols or one symbol
    #
    # @return [Boolean] whether or not user has role(s)
    def role?(role_sym)
      role_sym = [role_sym] unless role_sym.is_a?(Array)

      roles.map { |r| r.name.underscore.to_sym }.any? { |user_role| role_sym.include?(user_role) }
    end

    def self.integral_icon
      'user'
    end

    # @return [Array] containing available locales
    def self.available_locales
      available_locales = []

      Integral.backend_locales.each do |locale|
        available_locales << [I18n.t("integral.backend.users.available_locales.#{locale}"), locale]
      end

      available_locales
    end

    # @return [String] return the avatar filename
    def avatar_filename
      name
    end

    def valid_password?(password)
      return true if Rails.env.development?

      super
    end

    def multiple_page_notifications?
      notifications.count > Integral::Notification::Notification.per_page
    end

    # @param subscribable [Class or Instance]
    def receives_notifications_for?(subscribable)
      if subscribable.is_a?(Class)
        subscription = own_notification_subscriptions.find_by(subscribable_type: subscribable.name, subscribable_id: nil)

        return subscription.subscribed? if subscription
      else
        instance_subscription = own_notification_subscriptions.find_by(subscribable_type: subscribable.class.name, subscribable_id: subscribable.id)

        return instance_subscription.subscribed? if instance_subscription

        class_level_subscription = own_notification_subscriptions.find_by(subscribable_type: subscribable.class.name, subscribable_id: nil)

        return class_level_subscription.subscribed? if class_level_subscription
      end

      notify_me
    end

    def active_for_authentication?
      super && !blocked?
    end

    def inactive_message
      blocked? ? :blocked : super
    end

    private

    def send_devise_notification(notification, *args)
      devise_mailer.send(notification, self, *args).deliver_later
    end
  end
end
