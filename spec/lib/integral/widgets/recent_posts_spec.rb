require "rails_helper"

module Integral
  module Widgets
    describe RecentPosts do
      let(:posts) { Integral::Post.published.limit(2) }
      let(:render_options) { {
        partial: 'integral/posts/collection',
        locals: {
          collection: posts
        },
        layout: false
      } }

      describe '.render' do
        before do
          create(:integral_post, status: Integral::Post.statuses[:draft], tag_list: 'foo bar baz'.split)
          create(:integral_post, status: Integral::Post.statuses[:published], tag_list: 'foo bar baz'.split)
          create(:integral_post, status: Integral::Post.statuses[:published], tag_list: 'foo bar baz'.split)
          create(:integral_post, status: Integral::Post.statuses[:published], tag_list: 'foo bar baz'.split)
          create(:integral_post, status: Integral::Post.statuses[:published], tag_list: 'another-tag'.split)
        end

        context 'amount option' do
          context 'when amount is passed in' do
            let(:posts) { Integral::Post.published.limit(3) }

            it 'renders with set amount of posts' do
              expect(ApplicationController).to receive(:render).with(render_options)
              described_class.render(amount: 3)
            end
          end

          context 'when amount is not passed in' do
            it 'renders with default set amount of posts' do
              expect(ApplicationController).to receive(:render).with(render_options)
              described_class.render
            end
          end
        end

        context 'tagged option' do
          context 'when tagged is passed in' do
            let(:posts) { Integral::Post.published.tagged_with('foo bar'.split).limit(2) }

            it 'renders with set tagged posts' do
              expect(ApplicationController).to receive(:render).with(render_options)
              described_class.render(tagged: 'foo bar')
            end
          end

          context 'when tagged is not passed in' do
            it 'renders with all recent posts' do
              expect(ApplicationController).to receive(:render).with(render_options)
              described_class.render
            end
          end
        end
      end
    end
  end
end
