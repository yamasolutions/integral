module Integral
  # Handles Image authorization
  class ImagePolicy < BasePolicy
    # Allow all logged in users to access the images index
    def index?
      true
    end

    # @return [Symbol] role name
    def role_name
      :image_manager
    end
  end
end
