module Integral
  # Handles adding Integral behaviour to a class
  #
  # Dynamic backend menus handled by;
  # - ActsAsIntegral stores the backend menu items (backend_main_menu_items, backend_create_menu_items)
  # - acts_as_integral creates default content for menus which can be overridden by a class method
  # - acts_as_integral registers model with menu
  # - Backend helper loops over all registered items to create HTML snippet
  # - ActsAsIntegral provides way to add items not associated with acts_as_integral i.e. Homepage and settings (first and last items main menu items)
  module ActsAsIntegral
    class << self
      attr_writer :backend_main_menu_items
    end

    # Accessor for backend main menu items
    def self.backend_main_menu_items
      @backend_main_menu_items ||= []
    end

    # Adds item to main menu, expects Hash or Class
    def self.add_backend_main_menu_item(item)
      # duplicates are being added in development when app reloads
      duplicate_found = if item.class == Class
                          backend_main_menu_items.map(&:to_s).include?(item.to_s)
                        else
                          backend_main_menu_items.select { |item| item.is_a?(Hash) }.map {|item| item[:id] }.include?(item[:id])
                        end
      if duplicate_found
        Rails.logger.error("ActsAsIntegral: Item '#{item.to_s}' not added to menu as it already exists.")
      else
        backend_main_menu_items << item
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

            def url_helpers
              Integral::Engine.routes.url_helpers
            end
          end

          self.integral_options = {backend_main_menu: { visible: true, order: 11 }}.deep_merge(options)
          Integral::ActsAsIntegral.add_backend_main_menu_item(self) if integral_options.dig(:backend_main_menu, :visible)
        end
      end
    end
  end
end
