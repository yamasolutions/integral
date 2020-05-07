module Integral
  # Sets base policy for all objects to inherit
  class BasePolicy
    attr_reader :user, :instance

    # Initializes a policy instance which is used to handle authorization
    #
    # @param user [User] user policy is authorizing against
    # @param instance [Object] instance policy is authorizing against
    def initialize(user, instance)
      @user = user
      @instance = instance
    end

    # @return [Boolean] whether or not user has manager role
    def manager?
      user.role?(role_name) || user.admin?
    end

    def permitted_attribute?(attribute)
      permitted_attributes.include?(attribute)
    end

    def unpermitted_attribute?(attribute)
      !permitted_attribute?(attribute)
    end

    # @return [Array] attributes the user is authorization to edit
    def permitted_attributes
      raise NotImplementedError
    end

    private

    # @return [Symbol] role name
    def role_name
      raise NotImplementedError
    end

    alias destroy? manager?
    alias block? manager?
    alias unblock? manager?
    alias index? manager?
    alias list? manager?
    alias show? manager?
    alias new? manager?
    alias create? manager?
    alias edit? manager?
    alias update? manager?
    alias duplicate? manager?
    alias grid? manager?
    alias receives_notifications? manager?
  end
end
