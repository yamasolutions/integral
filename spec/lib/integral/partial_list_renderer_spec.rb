require "rails_helper"

module Integral
  describe PartialListItemRenderer do
    let(:rendered_list_item) { "<li>Some List Item!</li>" }
    let(:rendered_list) { "<div id=\"awesome-list\" class=\"foo bar swiper-container list-generated-swiper\"><div class='swiper-wrapper'><li>Some List Item!</li></div><div class='swiper-button-prev'></div><div class='swiper-button-next'></div><div class='swiper-pagination'></div></div>" }
    let(:list) { create(:integral_list_item_link) }

    # before do
    #   allow(ListItemRenderer).to receive(:render).and_return(rendered_list_item)
    # end

    describe '#render' do
      context 'when partial path option is missing' do
        it 'throws ArgumentError' do
          expect { described_class.render(list) }.to raise_error(ArgumentError)
        end
      end

      context 'when partial path option is present' do
        it 'returns rendered list inside partial' do
          expect(ApplicationController).to receive(:render)
          described_class.render(list, partial_path: 'partial-path')
        end
      end
    end
  end
end
