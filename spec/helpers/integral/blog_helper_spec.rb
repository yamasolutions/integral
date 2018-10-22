require 'rails_helper'

module Integral
  module Backend
    describe BlogHelper do
      describe '#display_newsletter_signup_widget?' do
        it 'returns true' do
          expect(helper.display_newsletter_signup_widget?).to eq true
        end
      end

      describe '#display_share_widget?' do
        context 'when current action is posts.show' do
          it 'returns true' do
            allow(helper).to receive(:controller_name).and_return(:posts)
            allow(helper).to receive(:action_name).and_return(:show)

            expect(helper.display_share_widget?).to eq true
          end
        end

        context 'when current action is not posts.show' do
          it 'returns false' do
            expect(helper.display_share_widget?).to eq false
          end
        end
      end

      describe '#display_recent_posts_widget?' do
        context 'when current action is posts.index' do
          it 'returns false' do
            allow(helper).to receive(:controller_name).and_return(:posts)
            allow(helper).to receive(:action_name).and_return(:index)

            expect(helper.display_recent_posts_widget?).to eq false
          end
        end

        context 'when current action is not posts.index' do
          it 'returns true' do
            expect(helper.display_recent_posts_widget?).to eq true
          end
        end
      end

      describe '#display_popular_posts_widget?' do
        let(:count) { double(count: 3) }

        before do
          allow(Integral::Post).to receive(:published).and_return(count)
        end

        context 'when published posts count is less than 4' do
          it 'returns false' do
            expect(helper.display_popular_posts_widget?).to eq false
          end
        end

        context 'when published posts count is greater than 4' do
          let(:count) { double(count: 5) }


          it 'returns true' do
            expect(helper.display_popular_posts_widget?).to eq true
          end
        end
      end
    end
  end
end
