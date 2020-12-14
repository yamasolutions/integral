module Integral
  # Blocks used to render dynamic content
  module Blocks
    # Outputs Book Now block
    class ContactForm < Base
      def self.name
        'integral/contact-form'
      end
    end
  end
end
