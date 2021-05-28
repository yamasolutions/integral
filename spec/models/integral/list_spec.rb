require 'rails_helper'

module Integral
  describe List do
    let(:list) { build(:integral_list) }

    subject { list }

    it 'has a valid factory' do
      expect(list.valid?).to be true
    end

    it "enables paper trail" do
      is_expected.to be_versioned
    end

    describe 'relations' do
      it { is_expected.to have_many :list_items }
    end

    describe 'validates' do
      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_uniqueness_of :title }
    end

    describe '.integral_icon' do
      it 'returns expected icon' do
        expect(described_class.integral_icon).to eq 'bi bi-list-ul'
      end
    end

    describe '#validate_unlocked' do
      context 'when locked' do
        it "can't be deleted" do
          list.locked = true
          list.destroy

          expect(list.destroy).to be_falsy
        end
      end

      context 'when not locked' do
        it "can be deleted" do
          list.destroy

          expect(list.destroy).to be_truthy
        end
      end
    end

    describe '#dup' do
      let(:list_item) { create(:integral_list_item) }
      let(:list_item_with_child) { create(:integral_list_item, children: [list_item]) }
      let(:list) { create(:integral_list, list_items: [list_item]) }
      let(:list_with_child) { create(:integral_list, list_items: [list_item_with_child]) }

      it 'returns expected list attributes' do
        clone = list.dup

        expect(clone.title).to eq list.title
        expect(clone.description).to eq list.description
      end

      xit 'returns expected list items' do
        clone = list_with_child.dup

        expect(clone.list_items.size).to eq list_with_child.list_items.size
        list_with_child.list_items.each do |list_item|
          cloned_item = clone.list_items.find{ |li| li.priority == list_item.priority }
          expect(cloned_item.title).to eq list_item.title
          expect(cloned_item.children.size).to eq list_item.children.size

          list_item.children.each do |child|
            cloned_child = cloned_item.children.find{ |li| li.priority == child.priority }

            expect(cloned_child.title).to eq child.title
          end
        end
      end
    end
  end
end
