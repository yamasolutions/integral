module Integral
  # Handles sending auto replys to visitors and passing on enquiries
  class ContactMailer < ActionMailer::Base
    layout 'integral/mailer'
    helper 'integral/mail'

    # Send supplied enquiry to contact email
    #
    # @param enquiry [Enquiry] enquiry which the visitor has created
    def forward_enquiry(enquiry)
      @enquiry = enquiry

      mail subject: forwarding_subject(enquiry), from: email_sender(enquiry.name, outgoing_email_address), to: incoming_email_address, reply_to: email_sender(enquiry.name, enquiry.email)
    end

    # Send an auto reply to the visitor of the supplied enquiry
    #
    # @param enquiry [Enquiry] enquiry which the visitor has created
    def auto_reply(enquiry)
      @enquiry = enquiry

      I18n.locale = @enquiry.context

      sender = email_sender(Integral::Settings.website_title, outgoing_email_address)

      mail subject: auto_reply_subject(enquiry), to: enquiry.email, from: sender, reply_to: sender
    end

    private

    # Override this to configure the outgoing email address
    def outgoing_email_address
      Integral::Settings.contact_email
    end

    # Override this to configure the incoming email address
    def incoming_email_address
      Integral::Settings.contact_email
    end

    # Builds the format so that email clients display name and email nicely
    def email_sender(name, email)
      "#{name} <#{email}>"
    end

    # Subject of the auto reply
    def auto_reply_subject(enquiry)
      I18n.t('integral.contact_mailer.auto_reply.subject', reference: enquiry.reference)
    end

    # Subject of the forwarding email
    # Adds the enquiry subject if it exists otherwise uses only reference
    def forwarding_subject(enquiry)
      if enquiry.subject.blank?
        return "#{enquiry.reference} #{I18n.t('integral.contact_mailer.forward_enquiry.subject')}"
      end

      "#{enquiry.reference} #{I18n.t('integral.contact_mailer.forward_enquiry.subject')} - #{enquiry.subject}"
    end
  end
end
