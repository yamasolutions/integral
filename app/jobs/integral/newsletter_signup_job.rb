module Integral
  # Carry out actual newsletter signing up process
  class NewsletterSignupJob < ApplicationJob
    rescue_from(Gibbon::MailChimpError) do |e|
      error_msg = "NewsletterSignupJob - Error when signing visitor up to Newsletter: #{e.message}"
      Rails.logger.error(error_msg)
    end

    # Attempts to signup an email to newsletter
    def perform(signup)
      return unless NewsletterSignup.api_available?

      gibbon = Gibbon::Request.new(api_key: Settings.newsletter_api_key)
      request_body = { email_address: signup.email, status: 'subscribed' }
      gibbon.lists(newsletter_list_id(signup)).members.create(body: request_body)

      # Update signup when the response is successful (in this case - if no error returned)
      signup.update_attribute(:processed, true)
    end

    # @return [String] The newsletter identifier to sign up to
    def newsletter_list_id(*)
      Settings.newsletter_list_id
    end
  end
end
