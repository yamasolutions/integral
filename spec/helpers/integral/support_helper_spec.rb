require 'rails_helper'

module Integral
  describe SupportHelper, type: :helper do
    describe '#anchor_to' do
      let(:body) { 'testbody' }
      let(:location) { 'testanchor' }
      let(:expected_path) { '/#testanchor' }

      it 'generates a link_to tag with current page and supplied anchor' do
        allow(helper).to receive(:url_for).and_return('/')
        expect(helper).to receive(:link_to).with(body, expected_path).and_return('test/url')

        expect(helper.anchor_to(body, location)).to eq 'test/url'
      end
    end
  end
end
