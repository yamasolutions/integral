module Integral
  # Google Lighthouse Interactions
  module Lighthouse
    # Represents a Lighthouse Audit
    #
    # https://developers.google.com/web/tools/lighthouse
    # https://github.com/GoogleChrome/lighthouse/blob/master/docs/readme.md
    class Audit < ApplicationRecord
      self.table_name = 'integral_lighthouse_audits'

      validates :url, :response, presence: true
    end
  end
end
