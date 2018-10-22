module Integral
  # Represents a contact enquiry made by visitors
  class Enquiry < ApplicationRecord
    acts_as_paranoid # Soft-deletion

    # Validations
    validates :email, presence: true
    validates_format_of :email, with: Devise.email_regexp
    validates :name, presence: true, length: { minimum: 3, maximum: 50 }, if: :validate_name?
    validates :subject, presence: true, length: { minimum: 3, maximum: 50 }, if: :validate_subject?
    validates :message, presence: true, length: { minimum: 10, maximum: 2500 }, if: :validate_message?

    # Callbacks
    after_create :process

    # Forward the enquiry on and send an auto reply. Create newsletter signup if necessary
    def process
      ContactMailer.forward_enquiry(self).deliver_later
      ContactMailer.auto_reply(self).deliver_later
      NewsletterSignup.create(name: name, email: email, context: context) if newsletter_opt_in?
    end

    # Reference used to uniquely identify the enquiry
    def reference
      num = 3008 + id
      "##{num}"
    end

    private

    # Conditional validation which can be easily overriden clientside
    def validate_name?
      false
    end

    # Conditional validation which can be easily overriden clientside
    def validate_message?
      false
    end

    # Conditional validation which can be easily overriden clientside
    def validate_subject?
      false
    end
  end
end
