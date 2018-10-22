require 'rails_helper'

module Integral
  describe ListDecorator do
    let(:list) { create(:integral_list) }

    subject { described_class.new(list) }

    describe '#url' do
      it 'provides the correct URL' do
        expect(subject.url).to eq "http://test.somehost.com/admin/lists/#{list.id}"
      end
    end
  end
end
