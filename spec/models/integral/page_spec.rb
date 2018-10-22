require 'rails_helper'

module Integral
  RSpec.describe Page, type: :model do
    let(:page) { build(:integral_page) }
    let(:acceptable_paths) { [ '/foo', '/foo/bar', '/123/456' ] }
    # TODO: Add // to unacceptable paths
    let(:unacceptable_paths) { [ 'foo', '/foo bar', '/foo?y=123', '/foo$' ] }

    it 'has a valid factory' do
      expect(page.valid?).to be true
    end

    it "enables paper trail" do
      is_expected.to be_versioned
    end

    describe 'relations' do
    end

    describe 'validates' do
      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_length_of(:title).is_at_least(Integral.title_length_minimum) }
      it { is_expected.to validate_length_of(:title).is_at_most(Integral.title_length_maximum) }
      it { is_expected.to validate_length_of(:description).is_at_least(Integral.description_length_minimum) }
      it { is_expected.to validate_length_of(:description).is_at_most(Integral.description_length_maximum) }

      it { is_expected.to validate_presence_of :path }
      it { is_expected.to validate_length_of(:path).is_at_most(100) }
      it { is_expected.to validate_uniqueness_of(:path).case_insensitive }

      it 'correct format of path' do
        acceptable_paths.each do |acceptable_path|
          expect(subject).to allow_value(acceptable_path).for(:path)
        end

        unacceptable_paths.each do |unacceptable_path|
          expect(subject).not_to allow_value(unacceptable_path).for(:path)
        end
      end
    end

    describe '#breadcrumbs' do
      let(:parent) { build(:integral_page, title: 'Parent') }
      let(:gparent) { build(:integral_page, title: 'GParent') }

      context 'when it has no breadrcrumbs' do
        let(:breadcrumbs) { [path: page.path, title: page.title] }
        it 'returns its own breadcrumb' do
          expect(page.breadcrumbs).to eq(breadcrumbs)
        end
      end

      context 'when it has one breadcrumb' do
        let(:breadcrumbs) { [{path: parent.path, title: parent.title}, {path: page.path, title: page.title}] }
        it 'returns itself and the breadcrumb' do
          page.parent = parent
          page.save

          expect(page.breadcrumbs).to eq(breadcrumbs)
        end
      end

      context 'when it has several breadcrumbs' do
        let(:breadcrumbs) { [{path: gparent.path, title: gparent.title}, {path: parent.path, title: parent.title}, {path: page.path, title: page.title}] }
        it 'returns itself and all other breadcrumbs' do
          parent.parent = gparent
          page.parent = parent
          page.save
          parent.save

          expect(page.breadcrumbs).to eq(breadcrumbs)
        end
      end
    end
  end
end
