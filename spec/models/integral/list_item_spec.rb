require 'rails_helper'

module Integral
  describe ListItem do
    subject { create(:integral_list_item, list: build(:integral_list, children: false)) }

    it 'has a valid factory' do
      expect(subject.valid?).to be true
    end

    describe 'relations' do
      it { is_expected.to belong_to :list }
    end

    describe '#validate_child_absence' do
      context 'when children are allowed' do
        it "can't save with children" do
          subject.list.children = true
          subject.children = [build(:integral_list_item)]

          expect(subject.valid?).to be_truthy
        end
      end

      context 'when children are not allowed' do
        it "can save with children" do
          subject.children = [build(:integral_list_item)]

          expect(subject.valid?).to be_falsy
        end
      end
    end

    describe '#link?' do
      it 'returns false' do
        expect(subject.link?).to eq false
      end
    end
  end
end
