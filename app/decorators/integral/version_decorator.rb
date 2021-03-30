module Integral
  # Page view-level logic
  class VersionDecorator < Draper::Decorator
    delegate_all

    # @return [String] URL to view version screen
    def url
      decorated_item&.activity_url(object.id)
    end

    # @return [String] formatted event
    def event
      h.t("integral.actions.#{object.event}")
    end

    # @return [String] formatted event verb (past)
    def event_verb
      h.t("integral.actions.tense.past.#{object.event}")
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
      user_id = object.whodunnit.to_i

      return '' if user_id.zero?

      @user = Integral::User.unscoped.find_by_id(object.whodunnit)&.decorate
    end

    # @return [String] image linked to whodunnit
    def whodunnit_avatar_url
      if whodunnit.present?
        whodunnit.decorate.avatar_url
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

    def item_class
      item_type.constantize
    end

    def item
      @item ||= item_class.unscoped.find_by_id(item_id)
    end

    # @return [String] formatted title
    def item_title
      decorated_item.present? ? decorated_item.title : '<deleted>'
    end

    # @return [Object] Associated Item
    def decorated_item
      @decorated_item ||= item&.decorate
    end

    # @return [String] Font Awesome icon
    def item_icon
      item_class.respond_to?(:integral_icon) ? item_class.integral_icon : 'ellipsis-v'
    end

    # @return [String] formatted item type
    def model_name
      item_class.model_name.human
    end

    # Currently not possible to show this as changeset isn't available in the query resultset for performance reasons - One possible solution would be to create a Grid class for each Version - rather than unioning all the tables it only includes it's own
    #
    # # @return [String] formatted attributes changed
    # def attributes_changed
    #   return unless object.event == 'update'
    #
    #   keys = ''
    #
    #   object.changeset.each_key do |key|
    #     # next if ['updated_at', 'lock_version'].include? key
    #     keys += "#{key}, "
    #   end
    #   keys[0..-3]
    # end
  end
end
