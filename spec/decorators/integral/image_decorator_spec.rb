require 'rails_helper'

module Integral
  describe ImageDecorator do
    let(:image) { create(:image) }

    subject { described_class.new(image) }

    describe '#backend_url' do
      it 'provides the correct URL' do
        expect(subject.backend_url).to eq "http://test.somehost.com/admin/images/#{image.id}/edit"
      end
    end
  end
end
