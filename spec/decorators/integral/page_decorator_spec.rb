require 'rails_helper'

module Integral
  describe PageDecorator do
    let(:page) { create(:integral_page) }

    subject { described_class.new(page) }

    describe '#backend_url' do
      it 'provides the correct URL' do
        expect(subject.backend_url).to eq "http://test.somehost.com/admin/pages/#{page.id}/edit"
      end
    end
  end
end
