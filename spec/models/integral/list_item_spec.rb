require 'rails_helper'

module Integral
  describe ListItem do
    subject { create(:integral_list_item, list: build(:integral_list, children: false)) }
    let(:types_collection) { [["Basic", "Integral::Basic", {:data=>{:true_value=>"Integral::Basic"}}],
     ["Link", "Integral::Link", {:data=>{:true_value=>"Integral::Link"}}],
     ["Page", "Integral::Page", {:data=>{:icon=>"file", :object_type=>"Integral::Page", :record_selector=>"integral-page", :true_value=>"Integral::Object"}}],
     ["Post", "Integral::Post", {:data=> {:icon=>"rss", :object_type=>"Integral::Post", :record_selector=>"integral-post", :true_value=>"Integral::Object"}}]] }

    it 'has a valid factory' do
      expect(subject.valid?).to be true
    end

    describe 'relations' do
      it { is_expected.to belong_to :list }
    end

    describe '.types_collection' do
      it 'returns list item types collection' do
        expect(described_class.types_collection).to eq types_collection
      end
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
