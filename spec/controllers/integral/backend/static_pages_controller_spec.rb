require 'rails_helper'

module Integral
  module Backend
    describe StaticPagesController, type: :controller do
      routes { Integral::Engine.routes }

      let(:user) { create :user }

      describe 'GET dashboard' do
        context 'when not logged in' do
          before do
            get :dashboard
          end

          it { expect(response).to redirect_to new_user_session_path  }
        end

        context 'when logged in' do
          before do
            sign_in user
            get :dashboard
          end

          it { expect(response.status).to eq 200 }
        end
      end
    end
  end
end
