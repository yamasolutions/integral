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

    # @return [String] Item URL
    def item_url
      decorated_item&.url
    end

    # @return [Integral::User] who carried out the version (if one exists)
    def whodunnit
      user_id = object.whodunnit.to_i

      return '' if user_id.zero?

      @user = Integral::User.unscoped.find_by_id(object.whodunnit)&.decorate
    end

    # @return [String] formatted title
    def item_title
      decorated_item&.title
    end

    # @return [Object] Associated Item
    def decorated_item
      @decorated_item ||= item&.decorate
    end

    # @return [String] formatted item type
    def item_type
      object.item_type.constantize.model_name.human
    end

    # @return [String] formatted attributes changed
    def attributes_changed
      return unless object.event == 'update'
      keys = ''

      object.changeset.each_key do |key|
        # next if ['updated_at', 'lock_version'].include? key
        keys += "#{key}, "
      end
      keys[0..-3]
    end
  end
end
