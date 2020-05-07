require 'rails_helper'

module Integral
  module Notification
    describe Subscribable do
      let(:post) { build(:integral_post, user: user) }
      let(:described_class) { Integral::Post }

      describe '.notifiable_users' do
        before do
          create_list(:integral_user, 5, user_options)
        end

        context 'when all users have top level notifications disabled' do
          let(:user_options) { { notify_me: false } }

          context 'when a user has top level notifications enabled' do
            let(:user) { create(:integral_user, notify_me: true) }

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end

          context 'when a user has class level notifications enabled' do
            let(:user) { create(:integral_user, notify_me: false) }

            before do
              user.self_notification_subscriptions.create!(subscribable: post, state: 'subscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end

          context 'when a user has object level notifications enabled' do
            let(:user) { create(:integral_user, notify_me: false) }

            before do
              user.self_notification_subscriptions.create!(subscribable_type: described_class, state: 'subscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end
        end

        context 'when all users have top level notifications enabled' do
          let(:user_options) { { notify_me: true } }

          context 'when a user has top level notifications disabled' do
            let(:user) { create(:integral_user, notify_me: false) }

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end

          context 'when a user has class level notifications disabled' do
            let(:user) { create(:integral_user, notify_me: true) }
            before do
              user.self_notification_subscriptions.create!(subscribable: post, state: 'unsubscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end

          context 'when a user has object level notifications disabled' do
            let(:user) { create(:integral_user, notify_me: true) }

            before do
              user.self_notification_subscriptions.create!(subscribable_type: described_class, state: 'unsubscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end
        end
      end


      describe '.notifiable_users' do
        before do
          create_list(:integral_user, 5, user_options)
        end

        context 'when all users have top level notifications disabled' do
          let(:user_options) { { notify_me: false } }

          context 'when a user has top level notifications enabled' do
            let(:user) { create(:integral_user, notify_me: true) }

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end

          context 'when a user has class level notifications enabled' do
            let(:user) { create(:integral_user, notify_me: false) }

            before do
              user.self_notification_subscriptions.create!(subscribable: post, state: 'subscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end

          context 'when a user has object level notifications enabled' do
            let(:user) { create(:integral_user, notify_me: false) }

            before do
              user.self_notification_subscriptions.create!(subscribable_type: described_class, state: 'subscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end
        end

        context 'when all users have top level notifications enabled' do
          let(:user_options) { { notify_me: true } }

          context 'when a user has top level notifications disabled' do
            let(:user) { create(:integral_user, notify_me: false) }

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end

          context 'when a user has class level notifications disabled' do
            let(:user) { create(:integral_user, notify_me: true) }
            before do
              user.self_notification_subscriptions.create!(subscribable: post, state: 'unsubscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end

          context 'when a user has object level notifications disabled' do
            let(:user) { create(:integral_user, notify_me: true) }

            before do
              user.self_notification_subscriptions.create!(subscribable_type: described_class, state: 'unsubscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end
        end
      end


      describe '.notifiable_users' do
        before do
          create_list(:integral_user, 5, user_options)
        end

        context 'when all users have top level notifications disabled' do
          let(:user_options) { { notify_me: false } }

          context 'when a user has top level notifications enabled' do
            let(:user) { create(:integral_user, notify_me: true) }

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end

          context 'when a user has class level notifications enabled' do
            let(:user) { create(:integral_user, notify_me: false) }

            before do
              user.self_notification_subscriptions.create!(subscribable: post, state: 'subscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end

          context 'when a user has object level notifications enabled' do
            let(:user) { create(:integral_user, notify_me: false) }

            before do
              user.self_notification_subscriptions.create!(subscribable_type: described_class, state: 'subscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq [user]
            end
          end
        end

        context 'when all users have top level notifications enabled' do
          let(:user_options) { { notify_me: true } }

          context 'when a user has top level notifications disabled' do
            let(:user) { create(:integral_user, notify_me: false) }

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end

          context 'when a user has class level notifications disabled' do
            let(:user) { create(:integral_user, notify_me: true) }
            before do
              user.self_notification_subscriptions.create!(subscribable: post, state: 'unsubscribe')
            end

            it 'returns correct users' do
              expect(post.notifiable_users).to eq Integral::User.where.not(id: user.id)
            end
          end

          context 'when a user has object level notifications disabled' do
            let(:user) { create(:integral_user, notify_me: true) }

            before do
              user.self_notification_subscriptions.create!(subscribable_type: described_class, state: 'unsubscribe')
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