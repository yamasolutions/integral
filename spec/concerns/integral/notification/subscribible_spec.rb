require 'rails_helper'

module Integral
  module Notification
    describe Subscribable do
      let(:post) { create(:integral_post, user: user) }
      let(:user_options) { { notify_me: notify_me } }
      let(:described_class) { Integral::Post }

      describe '.notifiable_users' do
        before do
          Integral::User.destroy_all
          create_list(:post_manager, 5, user_options)
        end

        context 'when all users have top level notifications disabled' do
          let(:notify_me) { false }

          context 'when a user has top level notifications enabled' do
            let(:user) { create(:post_manager, notify_me: true) }
            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end

          context 'when a user has class level notifications enabled' do
            let(:user) { create(:post_manager, notify_me: notify_me) }

            before do
              user.own_notification_subscriptions.create!(subscribable_type: described_class, state: 'subscribed')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end

          context 'when a user has instance level notifications enabled' do
            let(:user) { create(:post_manager, notify_me: notify_me) }

            before do
              user.own_notification_subscriptions.create!(subscribable: post, state: 'subscribed')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end
        end

        context 'when all users have top level notifications enabled' do
          let(:user_options) { { notify_me: true } }

          context 'when a user has top level notifications disabled' do
            let(:user) { create(:post_manager, notify_me: false) }

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end

          context 'when a user has class level notifications disabled' do
            let(:user) { create(:post_manager, notify_me: true) }

            before do
              user.own_notification_subscriptions.create!(subscribable_type: described_class, state: 'unsubscribed')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end

          context 'when a user has instance level notifications disabled' do
            let(:user) { create(:post_manager, notify_me: true) }

            before do
              user.own_notification_subscriptions.create!(subscribable: post, state: 'unsubscribed')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end
        end
      end
    end
  end
end
