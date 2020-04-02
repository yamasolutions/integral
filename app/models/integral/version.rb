# Integral namespace
module Integral
  # Base Version
  # class Version < PaperTrail::Version
  class Version < ApplicationRecord
    include PaperTrail::VersionConcern
    self.abstract_class = true

    # @return [Array] available version actions
    def self.available_actions
      available = []

      %w[update create destroy publish].each do |item|
        available << [I18n.t("integral.actions.#{item}"), item]
      end

      available
    end

    # @return [Array] available version objects
    def self.available_objects
      available = []

      [Integral::Post, Integral::Category, Integral::Page, Integral::List, Integral::Image, Integral::User].concat(Integral.additional_tracked_classes).each do |item|
        available << [item.model_name.human, item]
      end

      available
    end
  end
end
