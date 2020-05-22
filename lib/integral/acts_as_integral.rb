module Integral
  # Handles adding Integral behaviour to a class
  module ActsAsIntegral
    DEFAULT_OPTIONS ={ notifications: { enabled: true },
                       activity_tracking: { enabled: true },
                       cards: { at_a_glance: true, },
                       backend_main_menu: { enabled: true, order: 11 },
                       backend_create_menu: { enabled: true, order: 1 }}.freeze
    class << self
      attr_writer :backend_main_menu_items
      attr_writer :backend_create_menu_items
      attr_writer :backend_at_a_glance_card_items
      attr_writer :tracked_classes
    end

    # Accessor for backend main menu items
    def self.backend_main_menu_items
      @backend_main_menu_items ||= []
    end

    # Accessor for backend create menu items
    def self.backend_create_menu_items
      @backend_create_menu_items ||= []
    end

    # Accessor for at a glance card items
    def self.backend_at_a_glance_card_items
      @backend_at_a_glance_card_items ||= []
    end

    # Accessor for tracked classes
    def self.tracked_classes
      @tracked_classes ||= []
    end

    # Adds class to tracked_classes
    # @param [Class] item
    def self.add_tracked_class(item)
      tracked_classes << item unless duplicate_item?(item, tracked_classes)
    end

    # Adds item to main backend dashboard at a glance chart
    # @param [Class] item
    def self.add_backend_at_a_glance_card_item(item)
      backend_at_a_glance_card_items << item unless duplicate_item?(item, backend_at_a_glance_card_items)
    end

    # Adds item to create menu, expects Hash or Class
    def self.add_backend_create_menu_item(item)
      backend_create_menu_items << item unless duplicate_item?(item, backend_create_menu_items)
    end

    # Adds item to main menu, expects Hash or Class
    def self.add_backend_main_menu_item(item)
      backend_main_menu_items << item unless duplicate_item?(item, backend_main_menu_items)
    end

    # Checks for existing duplicates in list. Useful in development when app reloads
    def self.duplicate_item?(item, list)
      duplicate_found = if item.class == Class
                          list.map(&:to_s).include?(item.to_s)
                        else
                          list.select { |item| item.is_a?(Hash) }.map {|item| item[:id] }.include?(item[:id])
                        end

      if duplicate_found
        Rails.logger.debug("ActsAsIntegral: Item '#{item.to_s}' not added to list as it already exists.")
        true
      else
        false
      end
    end

    ActiveSupport.on_load(:active_record) do
      # ActiveRecord::Base extension
      class ActiveRecord::Base
        # Adds integral behaviour to models
        def self.acts_as_integral(options = {})
          class << self
            attr_accessor :integral_options

            # @return [Hash] hash representing the class, used to render within the main menu
            def integral_backend_main_menu_item
              {
                icon: integral_icon,
                order: integral_options.dig(:backend_main_menu, :order),
                label: model_name.human.pluralize,
                url: url_helpers.send("backend_#{model_name.route_key}_url"),
                # authorize: proc { policy(self).index? }, can't use this as self is in wrong context
                authorize_class: self,
                authorize_action: :index,
                list_items: [
                  { label: I18n.t('integral.navigation.dashboard'), url: url_helpers.send("backend_#{model_name.route_key}_url"), authorize_class: self, authorize_action: :index },
                  { label: I18n.t('integral.actions.create'), url: url_helpers.send("new_backend_#{model_name.singular_route_key}_url"), authorize_class: self, authorize_action: :new },
                  { label: I18n.t('integral.navigation.listing'), url: url_helpers.send("list_backend_#{model_name.route_key}_url"), authorize_class: self, authorize_action: :list },
                ]
              }
            end

            # @return [Hash] hash representing the class, used to render within the create menu
            def integral_backend_create_menu_item
              {
                icon: integral_icon,
                order: integral_options.dig(:backend_create_menu, :order),
                label: model_name.human,
                url: url_helpers.send("new_backend_#{model_name.singular_route_key}_url"),
                # authorize: proc { policy(self).index? }, can't use this as self is in wrong context
                authorize_class: self,
                authorize_action: :new,
              }
            end

            def url_helpers
              Integral::Engine.routes.url_helpers
            end
          end

          self.integral_options = Integral::ActsAsIntegral::DEFAULT_OPTIONS.deep_merge(options)
          Integral::ActsAsIntegral.add_backend_create_menu_item(self) if integral_options.dig(:backend_create_menu, :enabled)
          Integral::ActsAsIntegral.add_backend_main_menu_item(self) if integral_options.dig(:backend_main_menu, :enabled)
          Integral::ActsAsIntegral.add_backend_at_a_glance_card_item(self) if integral_options.dig(:cards, :at_a_glance)
          Integral::ActsAsIntegral.add_tracked_class(self) if integral_options.dig(:activity_tracking, :enabled)

          include Integral::Notification::Subscribable if integral_options.dig(:notifications, :enabled)
        end
      end
    end
  end
end
