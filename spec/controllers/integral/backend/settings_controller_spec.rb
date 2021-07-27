# require 'rails_helper'
#
# module Integral
#   module Backend
#     describe SettingsController do
#       routes { Integral::Engine.routes }
#
#       let(:user) { create(:integral_admin_user) }
#       let(:setting_params) { { website_title: 'Yama Solutions' }}
#
#       describe 'GET index' do
#         context 'when not logged in' do
#           it 'redirects to login page' do
#             get :index
#
#             expect(response).to redirect_to new_user_session_path
#           end
#         end
#
#         context 'when logged in' do
#           before do
#             sign_in user
#             get :index
#           end
#
#           context 'when user does not have required privileges' do
#             let(:user) { create :user }
#
#             before do
#               get :index
#             end
#
#             it { expect(response.status).to eq 302 }
#             it { expect(flash[:alert]).to eq I18n.t('errors.unauthorized') }
#           end
#
#           context 'when user has required privileges' do
#             before do
#               get :index
#             end
#
#             it { expect(response.status).to eq 200 }
#             it { expect(response).to render_template 'index' }
#           end
#         end
#       end
#
#       describe 'POST create' do
#         context 'when not logged in' do
#           it 'redirects to login page' do
#             post :create, params: { settings: setting_params }
#
#             expect(response).to redirect_to new_user_session_path
#           end
#         end
#
#         context 'when logged in' do
#           before { sign_in user }
#
#           context 'when valid params supplied' do
#             it 'redirects to the index page' do
#               post :create, params: { settings: setting_params }
#
#               expect(response).to redirect_to backend_settings_path
#             end
#
#             it 'updates settings' do
#               expect {
#                 post :create, params: { settings: setting_params }
#               }.to change(Settings, :count).by(1)
#               expect(Settings['website_title']).to eq 'Yama Solutions'
#             end
#           end
#         end
#       end
#     end
#   end
# end
