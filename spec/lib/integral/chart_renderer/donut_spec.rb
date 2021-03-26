require "rails_helper"

module Integral
  module ChartRenderer
    describe Donut do
      let(:dataset) {[
        { scope: Integral::Page, label: 'Total Pages' },
        { scope: Integral::List, label: 'Total Lists' },
        { scope: Integral::User, label: 'Total Users' }
      ]}
      let(:graph_markup) { "
                           <canvas data-chart data-chart-type='donut'>
                           <ul>
                           <li data-value='3'>= Total Pages: 3</li>
                           <li data-value='0'>= Total Lists: 0</li>
                           <li data-value='0'>= Total Users: 0</li>
                           </ul>
                           </canvas>
                           ".squish.gsub("\n", ' ') + ' ' }
      let(:no_data_markup) { ApplicationController.renderer.render(partial: "integral/backend/shared/graphs/no_data_available") }

      before do
        Integral::Page.delete_all
        Integral::List.delete_all
        Integral::User.delete_all
      end

      context 'when data is unavailable' do
        it 'renders not available markup' do
          expect(described_class.render(dataset)).to eq no_data_markup
        end
      end

      context 'when data is present' do
        it 'renders donut graph markup' do
          FactoryBot.create_list(:integral_page, 3)

          expect(described_class.render(dataset).gsub("\n", ' ')).to eq graph_markup
        end
      end
    end
  end
end
