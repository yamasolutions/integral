module Integral
  # Handles Post authorization
  class PostPolicy < BasePolicy
    # @return [Symbol] role name
    def role_name
      :post_manager
    end
  end
end
