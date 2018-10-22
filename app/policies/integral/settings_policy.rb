module Integral
  # Handles Settings authorization
  class SettingsPolicy < BasePolicy
    def manager?
      user.admin?
    end

    alias destroy? manager?
    alias index? manager?
    alias show? manager?
    alias new? manager?
    alias create? manager?
    alias edit? manager?
    alias update? manager?
    alias clone? manager?
  end
end
