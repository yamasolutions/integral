module Integral
  # User model used to represent a authenticated user
  class User < ApplicationRecord
    # Soft-deletion
    acts_as_paranoid

    mount_uploader :avatar, AvatarUploader
    process_in_background :avatar

    # Included devise modules. Others available are:
    # :confirmable, :timeoutable, :omniauthable, registerable and lockable
    devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

    # Relations
    has_many :role_assignments
    has_many :roles, through: :role_assignments

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

    private

    def send_devise_notification(notification, *args)
      devise_mailer.send(notification, self, *args).deliver_later
    end
  end
end
