require "rails_helper"

module Integral
  describe ContentRenderer do
    let(:raw_html) { "<li>Some List Item!</li>" }
    let(:widget_output) { "HELLO WORLD" }
    let(:raw_html_with_unavailable_widget) { "<p>Some content first</p><p class='integral-widget'></p><p>Some content last</p>" }
    let(:raw_html_without_widget) { "<p>Some content first</p><p class='integral-widget'></p><p>Some content last</p>" }
    let(:raw_html_with_widget) { "<p>Some content first</p><p class='integral-widget' data-widget-type='recent_posts' data-widget-value-tagged='foo'></p><p>Some content last</p>" }
    let(:rendered_html_without_widget) { "<p>Some content first</p>\n<!-- Widget not available --><p>Some content last</p>" }
    let(:rendered_html_with_widget) { "<p>Some content first</p>#{widget_output}<p>Some content last</p>" }

    describe '.render' do
      context 'when no widgets are present' do
        it 'returns unchanged HTML' do
          expect(described_class.render(raw_html)).to eq raw_html
        end
      end

      context 'when a widget is within the HTML' do
        context 'when widget is not registered' do
          it 'returns parsed HTML with placeholder content replaced with unavailable message' do
            expect(described_class.render(raw_html_without_widget)).to eq rendered_html_without_widget
          end
        end

        context 'when a widget is registered' do
          before do
            expect(Integral::Widgets::RecentPosts).to receive(:render).with({tagged:  'foo'}).and_return(widget_output)
          end

          it 'returns parsed HTML with placeholder content replaced' do
            expect(described_class.render(raw_html_with_widget)).to eq rendered_html_with_widget
          end
        end
      end
    end
  end
end
