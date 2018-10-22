module Integral
  # Handles visitor communications
  class ContactController < Integral.frontend_parent_controller.constantize
    # POST /contact
    def contact
      @enquiry = Enquiry.new(contact_params)

      if @enquiry.save
        head :created
      else
        head :unprocessable_entity
      end
    end

    # POST /newsletter_signup
    def newsletter_signup
      resource = NewsletterSignup.new(newsletter_signup_params)

      if resource.save
        head :created
      else
        head :unprocessable_entity
      end
    end

    private

    def contact_params
      params.require(:enquiry).permit(:name, :email, :message, :subject, :context, :newsletter_opt_in)
    end

    def newsletter_signup_params
      params.require(:newsletter_signup).permit(:email, :name, :context)
    end
  end
end
