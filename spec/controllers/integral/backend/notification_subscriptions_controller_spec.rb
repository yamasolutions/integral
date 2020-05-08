require 'rails_helper'

module Integral
  module Backend
    describe NotificationSubscriptionsController do
      routes { Integral::Engine.routes }

      let(:state) { 'foobar' }
      let(:params) { { subscribable_type: 'Integral::Post', state: state } }
      let(:user) { create(:post_manager) }

      describe 'PUT update' do
        context 'when not logged in' do
          before do
            put :update, params: { id: 1, subscription: params }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
            put :update, params: { id: 1, subscription: params }
          end

          context 'when valid parameters supplied' do
            it { expect(response).to have_http_status(:success) }
          end

          context 'when invalid parameters supplied' do
            let(:state) { '' }

            it { expect(response).to have_http_status(:unprocessable_entity) }
          end
        end
      end
    end
  end
end
