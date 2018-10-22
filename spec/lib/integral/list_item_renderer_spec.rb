require "rails_helper"

module Integral
  describe ListItemRenderer do
    let(:list_item_child) { create(:integral_list_item_link, url: '/sub-list-item-path', title: 'Sub List Item') }
    let(:list_item_no_child) { create(:integral_list_item_link, url: '/first-path', title: 'First List Item', html_classes: 'foo bar') }
    let(:list_item_with_child) { create(:integral_list_item_link, url: '/sub-list-path', title: 'Sub List', children: [list_item_child]) }
    let(:rendered_item_no_child) { "
      <li class=\"foo bar\"><a href=\"test.somehost.com/first-path\">First List Item</a></li>
    ".strip }
    let(:rendered_item_with_child) { "
      <li><a href=\"/sub-list-path\">Sub List</a>
        <ul>
          <li><a href=\"/sub-list-item-path\">Sub List Item</a></li>
        </ul>
      </li>
    ".strip.gsub(/\n\s+/, "") }

    describe '#render' do
      it 'renders list item' do
        expect(described_class.render(list_item_no_child)).to eq rendered_item_no_child
      end

      # context 'when list item contains children' do
      #   it 'renders list item and children' do
      #     expect(described_class.render(list_item_with_child)).to eq rendered_item_with_child
      #   end
      # end
    end

    let(:list_item) { create(:integral_list_item_basic) }
    let(:post) { create(:integral_post) }
    let(:list_item_object) { create(:integral_list_item_object, object_id: post.id, object_type: 'Integral::Post') }
    let(:list_item_object_with_override) { create(:integral_list_item_object, object_id: post.id, object_type: 0, title: 'Overide Title') }

    subject { described_class.new(list_item) }

    # TODO: Test all different attrs
    describe '#title' do
      context 'when an object is linked' do
        subject { described_class.new(list_item_object) }

        it 'returns the title of the object' do
          expect(subject.title).to eq post.title
        end

        context 'when override is given' do
          subject { described_class.new(list_item_object_with_override) }

          it 'returns overriden title' do
            expect(subject.title).to eq subject.list_item.title
          end
        end
      end

      it 'returns correct title' do
        expect(subject.title).to eq subject.list_item.title
      end
    end
  end
end
