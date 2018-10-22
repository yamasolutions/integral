module Integral
  # Represents levels of authorization
  class Role < ApplicationRecord
    has_many :role_assignments
    has_many :users, through: :role_assignments

    validates :name, presence: true

    # @return [String] label representing the Role
    def label
      I18n.t("integral.backend.roles.labels.#{name.underscore.downcase}")
    end
  end
end
