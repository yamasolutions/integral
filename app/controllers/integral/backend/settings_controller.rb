module Integral
  module Backend
    # Settings management
    class SettingsController < BaseController
      before_action :authorize_with_klass

      # GET /
      # Lists all settings
      def index; end

      # POST /
      # Update settings
      def create
        # Parse for booleans
        settings_params.each do |key, value|
          Settings[key] = parsed_value(value) if value.present?
        end

        flash[:notice] = t('integral.backend.settings.notification.successful_update')
        redirect_to backend_settings_path
      end

      private

      def resource_klass
        Integral::Settings
      end

      def parsed_value(value)
        return true if value == '_1'
        return false if value == '_0'

        value
      end

      def settings_params
        permitted_settings_params = %i[
          website_title contact_email newsletter_api_key newsletter_list_id github_url
          twitter_url facebook_url youtube_url linkedin_url instagram_url
          google_tag_manager_id facebook_app_id twitter_handler main_menu_list_id
        ]
        permitted_settings_params.concat Integral.additional_settings_params

        params[:settings].permit(*permitted_settings_params)
      end

      def render_default_action_bar?
        false
      end
    end
  end
end
