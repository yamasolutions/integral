require 'rails_helper'

module Integral
  RSpec.describe PostViewing, type: :model do
    let(:post) { create(:integral_post) }
    let(:viewing) { create(:integral_post_viewing) }
    let(:ip_address) { '192.168.1.1' }

    it 'has a valid factory' do
      expect(viewing.valid?).to be true
    end

    describe 'relations' do
      it { is_expected.to belong_to :post }
    end

    describe '.add' do
      context 'when viewing exists' do
        before do
          PostViewing.create!(post: post, ip_address: ip_address)
        end

        it 'does not add the viewing' do
          expect {
            described_class.add(post, ip_address)
          }.not_to change(PostViewing, :count)
        end

        it 'returns false' do
          expect(described_class.add(post, ip_address)).to be(false)
        end
      end

      context 'when viewing does not exist' do
        it 'adds the viewing' do
          expect {
            described_class.add(post, ip_address)
          }.to change(PostViewing, :count).by(1)
        end

        it 'returns true' do
          expect(described_class.add(post, ip_address)).to be(true)
        end
      end
    end
  end
end
