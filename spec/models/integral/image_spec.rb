require 'rails_helper'

module Integral
  describe Image do
    let(:image) { build(:image) }

    it 'has a valid factory' do
      expect(image.valid?).to be true
    end

    describe 'relations' do
    end

    describe 'validates' do
      it { is_expected.to validate_presence_of :file }
      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_length_of(:title).is_at_least(5) }
      it { is_expected.to validate_length_of(:title).is_at_most(50) }
      it { is_expected.to validate_length_of(:description).is_at_most(160) }
    end

    describe '.integral_icon' do
      it 'returns expected icon' do
        expect(described_class.integral_icon).to eq 'image'
      end
    end

    describe '#dimensions' do
      let(:height) { '1000' }
      let(:width) { '5000' }

      it 'returns expected dimensions' do
        image.height = height
        image.width = width
        expect(image.dimensions).to eq "#{width}x#{height}px"
      end
    end
  end
end
