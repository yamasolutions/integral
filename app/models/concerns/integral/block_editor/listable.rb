module Integral
  module BlockEditor
    module Listable
      extend ActiveSupport::Concern

      included do
        has_many :block_lists, as: :listable, class_name: 'Integral::BlockEditor::BlockList'
        has_one :active_block_list, class_name: 'Integral::BlockEditor::BlockList', as: :listable

        validates :active_block_list, presence: true

        accepts_nested_attributes_for :active_block_list

        after_initialize :set_block_list_defaults
      end

      private

      def set_block_list_defaults
        return if self.persisted?

        self.active_block_list ||= Integral::BlockEditor::BlockList.new
      end
    end
  end
end
