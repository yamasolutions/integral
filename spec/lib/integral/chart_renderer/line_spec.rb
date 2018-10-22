require "rails_helper"

module Integral
  module ChartRenderer
    describe Line do
      let(:last_week_in_days) {(1..7).collect { |i| (Date.today - i.day).strftime("%a")  }.join(',') }
      let(:dataset) {[
        { scope: Integral::Post, label: 'Posts' },
        { scope: Integral::Page, label: 'Pages' },
        { scope: Integral::User, label: 'Users' }
      ]}
      let(:graph_markup) { "
                           <canvas data-chart data-chart-labels='#{last_week_in_days}' data-chart-type='line'>
                           <ul data-chart-label='Posts'>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='1'></li>
                           <li data-value='3'></li>
                           <li data-value='3'></li>
                           <li data-value='7'></li>
                           </ul>
                           <ul data-chart-label='Pages'>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           </ul>
                           <ul data-chart-label='Users'>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           <li data-value='0'></li>
                           </ul>
                           </canvas>
                           ".squish.gsub("\n", ' ') + ' ' }
      let(:no_data_markup) { ApplicationController.renderer.render(partial: "integral/backend/shared/graphs/no_data_available") }

      before :each do
        Integral::Post.delete_all
        Integral::Page.delete_all
        Integral::User.delete_all
      end

      context 'when data is unavailable' do
        it 'renders not available markup' do
          expect(described_class.render(dataset)).to eq no_data_markup
        end
      end

      context 'when data is present' do
        it 'renders line graph markup' do
          user = FactoryBot.create(:integral_user)
          FactoryBot.create_list(:integral_post, 7, created_at: 1.day.ago, user: user)
          FactoryBot.create_list(:integral_post, 3, created_at: 2.day.ago, user: user)
          FactoryBot.create_list(:integral_post, 3, created_at: 3.day.ago, user: user)
          FactoryBot.create_list(:integral_post, 1, created_at: 4.day.ago, user: user)

          expect(described_class.render(dataset).gsub("\n", ' ')).to eq graph_markup
        end
      end
    end
  end
end

