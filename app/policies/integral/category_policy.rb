module Integral
  # Handles Category authorization
  class CategoryPolicy < BasePolicy
    # @return [Symbol] role name
    def role_name
      :post_manager
    end
  end
end
