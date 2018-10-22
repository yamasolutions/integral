require "rails_helper"

module Integral
  module Widgets
    describe SwiperList do
      let(:list_id) { 5 }
      let(:rendered_list) { "<li>Some List</li>" }
      let(:list_options) { {
        item_renderer: Integral::PartialListItemRenderer,
        html_classes: '',
        item_renderer_opts: {
          partial_path: 'integral/shared/record_card',
          wrapper_element: 'div',
          html_classes: 'swiper-slide',
          image_version: :small
        } } }

      describe '.render' do
        context 'when list_id is provided' do
          it 'returns rendered list' do
            expect(Integral::List).to receive(:find_by_id).with(list_id).and_return(:foo_list)
            expect(Integral::SwiperListRenderer).to receive(:render).with(:foo_list, list_options)
            described_class.render(list_id: list_id)
          end
        end

        context 'when list_id is not provided' do
          it { expect { described_class.render }.to raise_error(ArgumentError) }
        end
      end
    end
  end
end
