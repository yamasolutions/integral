module Integral
  # List item which is linked to a particular object i.e. A Post
  class Object < ListItem
    # Validations
    validates :object_type, :object_id, presence: true

    def object?
      true
    end

    # @return [Object] the object associated with the list item
    def object
      @object ||= object_klass.find_by_id(object_id)
    end

    # Sets the related object
    def object=(object)
      self.object_id = object.id
      self.object_type = object.class
    end

    private

    # Calculate the object class associated to the list item based on numeric value set within the modal
    # A numeric value is used rather than setting the actual class for security purposes
    def object_klass
      object_type.constantize
    end
  end
end
