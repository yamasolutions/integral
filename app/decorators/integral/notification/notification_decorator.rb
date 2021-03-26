module Integral
  module Notification
    class NotificationDecorator < Draper::Decorator
      delegate_all

      def formatted_action
        h.t("integral.actions.#{object.action}")
      end

      def action_verb
        h.t("integral.actions.tense.past.#{object.action}")
      end

      # @return [String] Item URL
      def item_url
        decorated_item&.backend_url
      end

      def whodunnit_url
        Integral::Engine.routes.url_helpers.backend_user_url(whodunnit.id) if whodunnit.present?
      end

      # @return [Integral::User] who carried out the version (if one exists)
      def whodunnit
        user_id = object.actor_id.to_i

        return '' if user_id.zero?

        @user = Integral::User.unscoped.find_by_id(object.actor_id)&.decorate
      end

      # @return [String] image linked to whodunnit
      def whodunnit_avatar_url
        if whodunnit.present?
          whodunnit.avatar_url
        else
          ActionController::Base.helpers.asset_path('integral/defaults/user_avatar.jpg')
        end
      end

      # @return [String] name linked to whodunnit
      def whodunnit_name
        if whodunnit.present?
          whodunnit.name
        else
          'System'
        end
      end

      def item
        @item ||= item_klass.unscoped.find_by_id(subscribable_id)
      end

      # @return [String] formatted title
      def item_title
        decorated_item.present? ? decorated_item.title : '<deleted>'
      end

      # @return [Object] Associated Item
      def decorated_item
        @decorated_item ||= item&.decorate
      end

      # @return [String] formatted item type
      def model_name
        item_klass.model_name.human
      end

      def item_klass
        subscribable_type.constantize
      end
    end
  end
end
