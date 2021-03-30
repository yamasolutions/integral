module Integral
  module Storage
    # Handles file authorization
    class FilePolicy < BasePolicy
      # @return [Symbol] role name
      def role_name
        :file_manager
      end
    end
  end
end
