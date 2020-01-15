module Integral
  # Handles listable behaviour
  module ActsAsListable
    class << self
      # Keeps a track of listable objects
      attr_writer :objects
     end

    # Accessor for listable objects
    def self.objects
      @objects ||= []
    end

    ActiveSupport.on_load(:active_record) do
      # ActiveRecord::Base extension
      class ActiveRecord::Base
        # Adds listable behaviour to objects
        def self.acts_as_listable(_options = {})
          Integral::ActsAsListable.objects << self

          # @return [Hash] instance as a list item
          # Keys include: id, title, subtitle, image, description, url
          def to_list_item
            raise NotImplementedError
          end

          # @return [Hash] listable options to be used within a RecordSelector widget.
          # Expects the following keys: record_title, selector_path, selector_title
          # TODO: Move these options into acts_as_listable initializer
          def self.listable_options
            raise NotImplementedError
          end

          before_save :touch_list_items

          # Touch all list items the instance is associated with
          def touch_list_items
            list_items = Integral::ListItem.where(type: 'Integral::Object', object_id: id, object_type: self.class.to_s)
            list_items.find_each(&:touch)
          end
        end
      end
    end
  end
end
