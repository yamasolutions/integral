require 'rails_helper'

module Integral
  describe VersionDecorator do
    let(:item) { create(:integral_post) }
    let(:resource) { double(event: :update, whodunnit: '', item: item, item_type: 'Integral::Post', id: 1, item_id: item.id) }

    subject { described_class.new(resource) }

    describe '#event' do
      it 'provides the formatted event' do
        expect(subject.event).to eq 'Update'
      end
    end

    describe '#url' do
      it 'to view screen' do
        expect(subject.url).to eq Integral::Engine.routes.url_helpers.activity_backend_post_url(item.id, subject.id)
      end
    end

    describe '#item_url' do
      it 'returns backend view URL of item' do
        expect(subject.item_url).to eq Integral::Engine.routes.url_helpers.backend_post_url(item.id)
      end
    end

    describe '#item_title' do
      it 'returns title' do
        expect(subject.item_title).to eq item.title
      end
    end

    describe '#decorated_item' do
      it 'returns decorated item' do
        expect(subject.decorated_item).to eq item.decorate
      end
    end

    describe '#model_name' do
      it 'returns formatted item type' do
        expect(subject.model_name).to eq 'Post'
      end
    end

    describe '#whodunnit' do
      context 'when no user is linked' do
        it 'returns blank' do
          expect(subject.whodunnit).to eq ''
        end
      end

      context 'when user is linked' do
        let!(:user) { create(:user) }
        let!(:resource) { double(whodunnit: user.id) }

        it 'returns decorated user' do
          expect(subject.whodunnit).to eq user.decorate
        end
      end
    end
  end
end
