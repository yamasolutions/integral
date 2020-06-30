module Integral
  class ListItemConnection < ApplicationRecord
    belongs_to :parent, touch: true, class_name: 'Integral::ListItem'
    belongs_to :child, touch: true, class_name: 'Integral::ListItem', dependent: :destroy
  end
end
