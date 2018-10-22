module Integral
  # Handles List authorization
  class ListPolicy < BasePolicy
    # @return [Symbol] role name
    def role_name
      :list_manager
    end
  end
end
