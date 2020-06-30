module Integral
  # Handles uploading user avatars
  class AvatarUploader < ImageUploader
    # Provide a default URL as a default if there hasn't been a file uploaded
    def default_url(*args)
      ActionController::Base.helpers.asset_path('integral/defaults/user_avatar.jpg')
    end
  end
end
