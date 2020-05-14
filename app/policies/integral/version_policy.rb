module Integral
  # Handles Activity authorization
  class VersionPolicy < BasePolicy
    def manager?
      user.admin?
    end

    alias activity? manager?
    alias activities? manager?
  end
end
