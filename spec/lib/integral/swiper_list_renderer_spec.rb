require "rails_helper"

module Integral
  describe SwiperListRenderer do
    let(:rendered_list_item) { "<li>Some List Item!</li>" }
    let(:rendered_list) { "<div id=\"awesome-list\" class=\"foo bar swiper-container list-generated-swiper\"><div class='swiper-wrapper'><li>Some List Item!</li></div><div class='swiper-button-prev'></div><div class='swiper-button-next'></div><div class='swiper-pagination'></div></div>" }
    let(:rendered_list_no_classes) { "<div id=\"awesome-list\" class=\" swiper-container list-generated-swiper\"><div class='swiper-wrapper'><li>Some List Item!</li></div><div class='swiper-button-prev'></div><div class='swiper-button-next'></div><div class='swiper-pagination'></div></div>" }
    let(:list) { create(:integral_list, html_classes: 'foo bar', html_id: 'awesome-list', list_items: [create(:integral_list_item_link)]) }
    let(:list_no_classes) { create(:integral_list, html_id: 'awesome-list', list_items: [create(:integral_list_item_link)]) }

    before do
      allow(ListItemRenderer).to receive(:render).and_return(rendered_list_item)
    end

    describe '#render' do
      context 'with classes' do
        it 'returns rendered list' do
          expect(described_class.render(list)).to eq rendered_list
        end
      end

      context 'without HTML classes' do
        it 'returns rendered list' do
          expect(described_class.render(list_no_classes)).to eq rendered_list_no_classes
        end
      end
    end
  end
end
