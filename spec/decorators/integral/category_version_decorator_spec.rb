require 'rails_helper'

module Integral
  describe CategoryVersionDecorator do
    let(:item) { create(:integral_category) }
    let(:user) { nil }
    let(:resource) { double(event: :update, whodunnit: user&.id, item: item, item_type: 'Integral::Category', id: 1, item_id: item.id, event: 'create') }

    subject { described_class.new(resource) }

    describe '#item_icon' do
      it 'returns item icon' do
        expect(subject.item_icon).to eq 'tags'
      end
    end
  end
end
