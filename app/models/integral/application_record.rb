module Integral
  # Base Integral Model.
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    # @return [Array] containing available human readable statuses against there numeric value
    def self.available_statuses(opts = { reverse: false })
      available_statuses = statuses.map do |key, value|
        [I18n.t("integral.statuses.#{key}"), key]
      end

      opts[:reverse] ? available_statuses.each(&:reverse!) : available_statuses
    end
  end
end
