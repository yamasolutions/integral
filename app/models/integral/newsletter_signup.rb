module Integral
  # Represents a Newsletter Signup
  class NewsletterSignup < ApplicationRecord
    # Validations
    validates :email, presence: true
    validates_format_of :email, with: Devise.email_regexp

    # Callbacks
    after_create :process

    def self.api_available?
      Settings.newsletter_api_key.present? && Settings.newsletter_list_id.present?
    end

    # Carry out the signup as long as the Newsletter API is available
    # TODO: Add a force parameter here
    # Default is set to false. Only processes it if processed is set to false (unless forced)
    def process
      NewsletterSignupJob.perform_later(self) if NewsletterSignup.api_available?
    end
  end
end
