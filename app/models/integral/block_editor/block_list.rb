module Integral
  module BlockEditor
    # Represents a block list
    class BlockList < ApplicationRecord
      has_paper_trail versions: { class_name: 'Integral::BlockEditor::BlockListVersion' }

      # Associations
      belongs_to :listable, polymorphic: true, touch: true
    end
  end
end
