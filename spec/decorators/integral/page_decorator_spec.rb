require 'rails_helper'

module Integral
  describe PageDecorator do
    let(:page) { create(:integral_page) }

    subject { described_class.new(page) }

    describe '#url' do
      it 'provides the correct URL' do
        expect(subject.url).to eq "http://test.somehost.com/admin/pages/#{page.id}/edit"
      end
    end
  end
end
