require 'rails_helper'

module Integral
  describe VersionDecorator do
    let(:item) { create(:integral_post) }
    let(:user) { nil }
    let(:resource) { double(event: :update, whodunnit: user&.id, item: item, item_type: 'Integral::Post', id: 1, item_id: item.id, event: 'create') }

    subject { described_class.new(resource) }

    describe '#event' do
      it 'provides the formatted event' do
        expect(subject.event).to eq 'Create'
      end
    end

    describe '#url' do
      it 'to view screen' do
        expect(subject.url).to eq Integral::Engine.routes.url_helpers.activity_backend_post_url(item.id, subject.id)
      end
    end

    describe '#event_verb' do
      it 'returns correct verb' do
        expect(subject.event_verb).to eq 'Created'
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

    describe '#item_icon' do
      it 'returns default item icon for versions' do
        expect(subject.item_icon).to eq 'ellipsis-v'
      end
    end

    describe '#title' do
      it 'returns copy describing the record' do
        expect(subject.model_name).to eq 'Post'
      end
    end

    describe '#whodunnit_avatar_url' do
      context 'when whodunnit is nil' do
        it 'returns default avatar' do
          expect(subject.whodunnit_avatar_url).to eq ActionController::Base.helpers.asset_path('integral/defaults/user_avatar.jpg')
        end
      end

      context 'when whodunnit is present' do
        let(:user) { create(:integral_user) }

        it 'returns user avatar URL' do
          allow_any_instance_of(User).to receive(:avatar).and_return(double(url: "custom-avatar"))

          expect(subject.whodunnit_avatar_url).to eq 'custom-avatar'
        end
      end
    end

    describe '#whodunnit_name' do
      context 'when whodunnit is nil' do
        it 'returns system' do
          expect(subject.whodunnit_name).to eq 'System'
        end
      end

      context 'when whodunnit is present' do
        let(:user) { create(:integral_user) }

        it 'returns user name' do
          expect(subject.whodunnit_name).to eq user.name
        end
      end
    end

    describe '#whodunnit_url' do
      context 'when whodunnit is nil' do
        it 'returns nil' do
          expect(subject.whodunnit_url).to eq nil
        end
      end

      context 'when whodunnit is present' do
        let(:user) { create(:integral_user) }

        it 'returns user profile URL' do
          expect(subject.whodunnit_url).to eq Integral::Engine.routes.url_helpers.backend_user_url(user.id)
        end
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
