module Integral
  # Handles Activity authorization
  class VersionPolicy < BasePolicy
    # For some reason authorize_with_klass seems to be delegating manager? calls to BasePolicy rather than using the override
    # app/controllers/integral/backend/activities_controller.rb:37:in `authorize_with_klass'
    # @return [Boolean] whether or not user has manager access
    def index?
      manager?
    end

    def manager?
      user.admin?
    end

    alias grid? manager?
    alias activity? manager?
    alias activities? manager?
  end
end
