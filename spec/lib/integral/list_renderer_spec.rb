require "rails_helper"

module Integral
  describe ListRenderer do
    let(:rendered_list_item) { "<li>Some List Item!</li>" }
    let(:rendered_list) { "<ul id=\"awesome-list\" class=\"foo bar\">#{rendered_list_item}</ul>" }
    let(:list) { create(:integral_list, html_classes: 'foo bar', html_id: 'awesome-list', list_items: [create(:integral_list_item_link)]) }

    before do
      allow(ListItemRenderer).to receive(:render).and_return(rendered_list_item)
    end

    describe '#render' do
      it 'returns rendered list' do
        expect(described_class.render(list)).to eq rendered_list
      end
    end
  end
end
