require 'rails_helper'

module Ckeditor
  describe Picture do
    let(:url) { 'some_random_url' }

    subject { described_class.new }

    before do
      allow(subject).to receive(:url).and_return(url)
    end

    describe '#url_content' do
      it 'returns url' do
        expect(subject.url_content).to eq url
      end
    end

    describe '#url_thumb' do
      it 'returns url' do
        expect(subject.url_thumb).to eq url
      end
    end
  end
end
