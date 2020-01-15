require 'rails_helper'

module Integral
  module Backend
    describe ListsController do
      routes { Integral::Engine.routes }

      let(:title) { 'foobar title' }
      let(:description) { Faker::Lorem.paragraph(8)[0..150] }
      let(:resource_params) { { title: title, description: description } }
      let(:user) { create(:list_manager) }

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
          end

          context 'when user has required privileges' do
            before do
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.lists'), :backend_lists_path)

              get :index
            end

            it { expect(response.status).to eq 200 }
            it { expect(response).to render_template 'index' }
          end
        end
      end

      describe 'POST create' do
        context 'when not logged in' do
          it 'redirects to login page' do
            post :create, params: { list: resource_params }

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
              post :create, params: { list: resource_params }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required privileges' do
            context 'when valid resource params supplied' do
              it 'returns status created' do
                post :create, params: { list: resource_params }

                expect(response).to redirect_to edit_backend_list_path(assigns[:resource])
              end

              it 'saves a new record' do
                expect {
                  post :create, params: { list: resource_params }
                }.to change(List, :count).by(1)
              end
            end

            context 'when invalid record params supplied' do
              it 'does not save a new record' do
                expect {
                  post :create, params: { list: resource_params.merge!(title: '') }
                }.not_to change(Page, :count)
              end
            end
          end
        end
      end

      describe 'GET new' do
        context 'when not logged in' do
          before { get :new }

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
          end

          context 'when user does not have required privileges' do
            let(:user) { create :user }

            before do
              get :new
            end

            it { expect(response.status).to eq 302 }
          end


          context 'when user has required privileges' do
            before do
              allow(Integral::List).to receive(:new).and_return :foo
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.lists'), :backend_lists_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.new'), :new_backend_list_path)

              get :new
            end

            it { expect(response.status).to eq 200 }
            it { expect(assigns(:resource)).to eq :foo }
            it { expect(response).to render_template 'new' }
          end
        end
      end

      describe 'GET edit' do
        let(:list) { create(:integral_list) }

        context 'when not logged in' do
          before do
            get :edit, params: { id: list.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
          end

          context 'when user does not have required privileges' do
            let(:user) { create :user }

            before do
              get :edit, params: { id: list.id }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required privileges' do
            before do
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.lists'), :backend_lists_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.edit'), :edit_backend_list_path)
              get :edit, params: { id: list.id }
            end

            it { expect(assigns[:resource]).to eq list }
            it { expect(response).to render_template 'edit' }
          end
        end
      end

      describe 'PUT update' do
        let(:record) { create(:integral_list) }

        context 'when not logged in' do
          before do
            put :update, params: { id: record.id, list: resource_params }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
          end

          context 'when user does not have required privileges' do
            let(:user) { create :user }

            before do
              put :update, params: { id: record.id, list: resource_params }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required privileges' do
            before do
              put :update, params: { id: record.id, list: resource_params }
              record.reload
            end

            context 'when valid parameters supplied' do
              it { expect(response).to redirect_to(edit_backend_list_path(assigns[:resource])) }
              it { expect(record.title).to eql title }
              it { expect(record.description).to eql description }
            end

            context 'when invalid parameters supplied' do
              let(:title) { '' }

              it { expect(record.title).not_to eql title }
              it { expect(record.description).not_to eql description }
              it { expect(response).to render_template 'edit' }
            end
          end
        end
      end

      describe 'DELETE destroy' do
        let(:record) { create(:integral_list) }

        context 'when not logged in' do
          before do
            delete :destroy, params: { id: record.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          context 'when user does not have required privileges' do
            let(:user) { create :user }

            before do
              sign_in user
              delete :destroy, params: { id: record.id }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required privileges' do
            before do
              sign_in user
              delete :destroy, params: { id: record.id }
            end

            it { expect(record.reload.deleted?).to be true }
            it { expect(response).to redirect_to backend_lists_path }
          end

          context 'when a problem occurs destroying' do
            before do
              allow_any_instance_of(Integral::List).to receive(:destroy).and_return(false)
              sign_in user
              delete :destroy, params: { id: record.id }
            end

            it { expect(record.reload.deleted?).to be false }
            it { expect(response).to redirect_to backend_lists_path }
          end
        end
      end
    end
  end
end
