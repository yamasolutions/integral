require "rails_helper"

module Integral
  describe ButtonLinkRenderer do
    let(:text) { 'Button Text' }
    let(:target) { 'Button Target' }
    let(:button_markup) { '<button>Button Text</button>' }
    let(:pagination_markup) { "<ul class=\"pagination \"><li class=\"current\"><span>1</span></li><li><button rel=\"next\" data-page=\"2\">2</button></li><li><button data-page=\"3\">3</button></li><li><button data-page=\"4\">4</button></li></ul>" }
    let(:collection) { double(current_page: 1) }

    subject { ButtonLinkRenderer.new }

    describe '#url' do
      it 'returns page number' do
        expect(subject.url(1337)).to eq 1337
      end
    end

    describe '#link' do
      it 'returns button markup' do
        expect(subject.link(text, target)).to eq button_markup
      end
    end

    describe '#to_html' do
      it 'returns pagination markup' do
        allow(subject).to receive(:pagination).and_return [1,2,3,4]
        subject.instance_variable_set(:@options, {})
        subject.instance_variable_set(:@collection, collection)

        expect(subject.to_html).to eq pagination_markup
      end
    end
  end
end
