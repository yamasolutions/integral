require 'rails_helper'

module Integral
  module Backend
    describe CategoriesController do
      routes { Integral::Engine.routes }

      let(:title) { 'foobar title' }
      let(:slug) { 'foobar-title' }
      let(:description) { Faker::Lorem.paragraph(8)[0..150] }
      let(:params) { { title: title, description: description, slug: slug } }
      let(:user) { create(:post_manager) }
      let!(:category) { create(:integral_category) }

      describe 'POST create' do
        context 'when not logged in' do
          it 'redirects to login page' do
            post :create, params: { post: params }

            expect(response).to redirect_to new_user_session_path
          end
        end

        context 'when logged in' do
          before { sign_in user }

          context 'when valid params supplied' do
            it 'responds successfully to the saved category' do
              post :create, params: { category: params }

              expect(response).to have_http_status(:created)
            end

            it 'saves a new record' do
              expect {
                post :create, params: { category: params }
              }.to change(Category, :count).by(1)
            end
          end

          context 'when invalid params supplied' do
            it 'does not save a new record' do
              expect {
                post :create, params: { category: params.merge!(title: '') }
              }.not_to change(Category, :count)
            end

            it 'responds unsuccessfully' do
              post :create, params: { category: params.merge!(title: '') }

              expect(response).to have_http_status(:unprocessable_entity)
            end
          end
        end
      end

      describe 'GET edit' do
        context 'when not logged in' do
          before do
            get :edit, params: { id: category.id }
        end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
            get :edit, params: { id: category.id }
          end

          it { expect(assigns[:resource]).to eq category }
          it { expect(response).to have_http_status(:success) }
        end
      end

      describe 'PUT update' do
        context 'when not logged in' do
          before do
            put :update, params: { id: category.id, category: params }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
            put :update, params: { id: category.id, category: params }
            category.reload
          end

          context 'when valid parameters supplied' do
            it { expect(response).to have_http_status(:success) }
          end

          context 'when invalid parameters supplied' do
            let(:title) { '' }

            it { expect(response).to have_http_status(:unprocessable_entity) }
          end
        end
      end

      describe 'DELETE destroy' do
        context 'when not logged in' do
          before do
            delete :destroy, params: { id: category.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
            delete :destroy, params: { id: category.id }
          end

          # it { expect(category.reload.deleted?).to be true }
          it { expect(response).to redirect_to backend_categories_path }
        end
      end
    end
  end
end
