module Integral
  # Google Lighthouse Interactions
  module Lighthouse
    # Represents a Lighthouse Audit
    #
    # https://developers.google.com/web/tools/lighthouse
    # https://github.com/GoogleChrome/lighthouse/blob/master/docs/readme.md
    class Audit < ApplicationRecord
      self.table_name = 'integral_lighthouse_audits'

      belongs_to :auditable, polymorphic: true

      validates :url, :response, presence: true

      # Scopes
      scope :search, ->(query) { where('lower(url) LIKE ?', "%#{query.downcase}%") }
    end
  end
end
