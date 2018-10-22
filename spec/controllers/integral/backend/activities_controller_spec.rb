require 'rails_helper'

module Integral
  module Backend
    describe ActivitiesController do
      routes { Integral::Engine.routes }

      let(:user) { create(:integral_admin_user) }

      describe 'GET index' do
        context 'when not logged in' do
          it 'redirects to login page' do
            get :index

            expect(response).to redirect_to new_user_session_path
          end
        end

        context 'when logged in' do
          before do
            sign_in user
          end

          context 'when user does not have required privileges' do
            let(:user) { create :user }

            before do
              get :index
            end

            it { expect(response.status).to eq 302 }
            it { expect(flash[:alert]).to eq I18n.t('errors.unauthorized') }
          end

          context 'when user has required privileges' do
            before do
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_url)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.activity'), :backend_activities_url)

              get :index
            end

            it { expect(response.status).to eq 200 }
            it { expect(response).to render_template 'index' }
          end
        end
      end
    end
  end
end
