require 'rails_helper'

module Integral
  module Backend
    describe UsersController do
      routes { Integral::Engine.routes }

      let(:presented_user) { create(:user) }
      let(:user) { create(:user_manager) }
      let(:builder) { build(:user) }
      let(:name) { builder.name }
      let(:email) { builder.email }
      let(:password) { builder.password }
      let(:role_ids) { Role.ids }
      let(:user_params) { { name: name, email: email, password: password, password_confirmation: password, role_ids: role_ids } }

      describe 'GET index' do
        context 'when not logged in' do
          it 'redirects to login page' do
            get :index

            expect(response).to redirect_to new_user_session_path
          end
        end

        context 'when logged in' do
          # TODO: Work out how to stub a grid
          #let(:users_grid) { initialize_grid(User) }

          before do
            sign_in user
          end

          context 'when user does not have required roles' do
            let(:user) { create :user }

            before do
              get :index
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has the require roles' do
            before do
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.users'), :backend_users_path)

              get :index
            end

            it { expect(response.status).to eq 200 }
            it { expect(response).to render_template 'index' }
            xit { expect(assigns[:users_grid]).to eq users_grid }
          end
        end
      end

      describe 'POST create' do
        context 'when not logged in' do
          it 'redirects to login page' do
            post :create, params: { user: user_params }

            expect(response).to redirect_to new_user_session_path
          end
        end

        context 'when logged in' do
          before do
            allow_any_instance_of(User).to receive(:deliver_invitation)
            sign_in user
          end

          context 'when user does not have required roles' do
            let(:user) { create :user }

            before do
              post :create, params: { user: user_params }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when valid post params supplied' do
            it 'redirects to the saved user' do
              post :create, params: { user: user_params }

              expect(flash[:notice]).to eql(I18n.t('integral.backend.users.notification.creation_success'))
              expect(response).to redirect_to backend_user_path(User.last)
            end

            it 'saves a new user' do
              expect {
                post :create, params: { user: user_params }
              }.to change(User, :count).by(1)
            end

            it 'sets the correct attributes' do
              post :create, params: { user: user_params }

              new_user = assigns[:user]
              expect(new_user.name).to eq name
              expect(new_user.email).to eq email
              expect(new_user.password).to eq password
              expect(new_user.role_ids).to eq role_ids
            end
          end

          context 'when invalid post params supplied' do
            it 'does not save a new user' do
              expect {
                post :create, params: { user: user_params.merge!(email: '') }
              }.not_to change(User, :count)
            end

            it 'renders new template' do
              post :create, params: { user: user_params.merge!(email: '') }

              expect(flash[:error]).to eql(I18n.t('integral.backend.users.notification.creation_failure'))
              expect(response).to render_template("new")
            end
          end
        end
      end

      describe 'GET show' do
        context 'when not logged in' do
          it 'redirects to login page' do
            get :show, params: { id: user.id }

            expect(response).to redirect_to new_user_session_path
          end
        end

        context 'when logged in' do
          before do
            sign_in user
          end

          context 'when user does not have required roles' do
            let(:user) { create :user }

            before do
              get :show, params: { id: presented_user.id }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required roles' do
            before do
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.users'), :backend_users_path)
              expect(controller).to receive(:add_breadcrumb).with(presented_user.name, :backend_user_path)

              get :show, params: { id: presented_user.id }
            end

            it { expect(assigns[:user]).to eq presented_user }
            it { expect(response).to render_template 'show' }
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
            allow(User).to receive(:new).and_return :foo
          end

          context 'when user does not have required roles' do
            let(:user) { create :user }

            before do
              get :new
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required roles' do
            before do
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.users'), :backend_users_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.new'), :new_backend_user_path)

              get :new
            end

            it { expect(response.status).to eq 200 }
            it { expect(assigns(:user)).to eq :foo }
            it { expect(response).to render_template 'new' }
          end
        end
      end

      describe 'GET edit' do
        context 'when not logged in' do
          before do
            get :edit, params: { id: user.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
          end

          context 'when user does not have required roles' do
            let(:user) { create :user }

            before do
              get :edit, params: { id: presented_user.id }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when the user has the required roles' do
            before do
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.users'), :backend_users_path)
              expect(controller).to receive(:add_breadcrumb).with(user.name, :backend_user_path)
              expect(controller).to receive(:add_breadcrumb).with(I18n.t('integral.breadcrumbs.edit'), :edit_backend_user_path)

              get :edit, params: { id: user.id }
            end


            it { expect(assigns[:user]).to eq user }
            it { expect(response).to render_template 'edit' }
          end
        end
      end

      describe 'PUT update' do
        let(:actionable_user) { create(:user) }

        context 'when not logged in' do
          before do
            put :update, params: { id: user.id, user: user_params }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user

            put :update, params: { id: actionable_user.id, user: user_params }
            assigns[:user].reload
          end

          context 'when user does not have required privileges' do
            let(:user) { create :user }

            it { expect(response.status).to eq 302 }
            it { expect(flash[:alert]).to eq I18n.t('errors.unauthorized') }
          end

          context 'when user does not have required privileges to update roles' do
            let(:user) { create :user }
            let(:actionable_user) { user }

            it { expect(response).to redirect_to(backend_user_path(actionable_user)) }
            it { expect(assigns[:user].name).to eql name }
            it { expect(assigns[:user].email).to eql email }
            it { expect(assigns[:user].password).to eql password }
            it { expect(assigns[:user].role_ids).not_to match_array role_ids }
          end

          context 'when user has required privileges' do
            context 'when valid parameters supplied' do
              it { expect(response).to redirect_to(backend_user_path(actionable_user)) }
              it { expect(flash[:notice]).to eql(I18n.t('integral.backend.users.notification.edit_success')) }
              it { expect(assigns[:user].name).to eql name }
              it { expect(assigns[:user].email).to eql email }
              it { expect(assigns[:user].password).to eql password }
              it { expect(assigns[:user].role_ids).to match_array role_ids }
            end

            context 'when invalid parameters supplied' do
              let(:name) { '' }

              it { expect(assigns[:user].name).not_to eql name }
              it { expect(assigns[:user].email).not_to eql email }

              it { expect(flash[:error]).to eql(I18n.t('integral.backend.users.notification.edit_failure')) }
              it { expect(response).to render_template 'edit' }
            end
          end
        end
      end

      describe 'DELETE destroy' do
        context 'when not logged in' do
          before do
            delete :destroy, params: { id: user.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
            delete :destroy, params: { id: user.id }
          end

          context 'when user does not have required roles' do
            let(:user) { create :user }

            it { expect(response.status).to eq 302 }
          end

          it { expect(user.reload.deleted?).to be true }
          it { expect(flash[:notice]).to eql(I18n.t('integral.backend.users.notification.delete_success')) }
          it { expect(response).to redirect_to backend_users_path }
        end
      end
    end
  end
end
