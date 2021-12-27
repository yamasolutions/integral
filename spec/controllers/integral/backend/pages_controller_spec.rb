require 'rails_helper'

module Integral
  module Backend
    describe PagesController do
      routes { Integral::Engine.routes }

      let(:title) { 'foobar title' }
      let(:description) { Faker::Lorem.paragraph(sentence_count: 8)[0..150] }
      let(:path) { '/foo/bar' }
      let(:page_params) { { title: title, description: description, path: path } }
      let(:user) { create(:page_manager) }

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
            let(:pages_sorted) { Page.all.order('created_at DESC') }

            before do
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
            post :create, params: { page: page_params }

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
              post :create, params: { page: page_params }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required privileges' do
            context 'when valid page params supplied' do
              it 'returns status created' do
                post :create, params: { page: page_params }

                expect(response).to redirect_to edit_backend_page_path(assigns[:resource])
              end

              it 'saves a new page' do
                expect {
                  post :create, params: { page: page_params }
                }.to change(Page, :count).by(1)
              end
            end

            context 'when invalid page params supplied' do
              it 'does not save a new page' do
                expect {
                  post :create, params: { page: page_params.merge!(title: '') }
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
              allow(Integral::Page).to receive(:new).and_return :foo

              get :new
            end

            it { expect(response.status).to eq 200 }
            it { expect(assigns(:resource)).to eq :foo }
            it { expect(response).to render_template 'new' }
          end
        end
      end

      describe 'GET edit' do
        let(:page) { create(:integral_page) }

        context 'when not logged in' do
          before do
            get :edit, params: { id: page.id }
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
              get :edit, params: { id: page.id }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required privileges' do
            before do
              get :edit, params: { id: page.id }
            end

            it { expect(assigns[:resource]).to eq page }
            it { expect(response).to render_template 'edit' }
          end
        end
      end

      describe 'PUT update' do
        let(:page) { create(:integral_page) }

        context 'when not logged in' do
          before do
            put :update, params: { id: page.id, page: page_params }
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
              put :update, params: { id: page.id, page: page_params }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required privileges' do
            before do
              put :update, params: { id: page.id, page: page_params }
              page.reload
            end

            context 'when valid parameters supplied' do
              it { expect(response).to redirect_to(edit_backend_page_path(assigns[:resource])) }
              it { expect(page.title).to eql title }
              it { expect(page.description).to eql description }
              it { expect(page.path).to eql path }
            end

            context 'when invalid parameters supplied' do
              let(:title) { '' }

              it { expect(page.title).not_to eql title }
              it { expect(page.description).not_to eql description }
              it { expect(response).to render_template 'edit' }
            end
          end
        end
      end

      describe 'DELETE destroy' do
        let(:page) { create(:integral_page) }

        context 'when not logged in' do
          before do
            delete :destroy, params: { id: page.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          context 'when user does not have required privileges' do
            let(:user) { create :user }

            before do
              sign_in user
              delete :destroy, params: { id: page.id }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required privileges' do
            before do
              sign_in user
              delete :destroy, params: { id: page.id }
            end

            it { expect(page.reload.deleted?).to be true }
            it { expect(response).to redirect_to backend_pages_path }
          end

          context 'when no problem occurs destroying' do
            before do
              allow_any_instance_of(Integral::Page).to receive(:destroy).and_return(false)
              sign_in user
              delete :destroy, params: { id: page.id }
            end

            it { expect(page.reload.deleted?).to be false }
            it { expect(response).to redirect_to backend_pages_path }
          end
        end
      end

      describe 'GET activities' do
        let(:page) { create(:integral_page) }

        context 'when not logged in' do
          before do
            delete :activities, params: { id: page.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          context 'when user does not have required privileges' do
            let(:user) { create :user }

            before do
              sign_in user
              get :activities, params: { id: page.id }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required privileges' do
            let(:user) { create :integral_admin_user }

            before do
              sign_in user
              get :activities, params: { id: page.id }
            end

            it { expect(response.status).to eq 200 }
          end
        end
      end

      describe 'GET activity', versioning: true do
        let!(:page) { create(:integral_page) }

        context 'when not logged in' do
          before do
            delete :activity, params: { id: page.id, activity_id: page.versions.last.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          context 'when user does not have required privileges' do
            let(:user) { create :user }

            before do
              sign_in user
              get :activity, params: { id: page.id, activity_id: page.versions.last.id }
            end

            it { expect(response.status).to eq 302 }
          end

          context 'when user has required privileges' do
            let(:user) { create :integral_admin_user }

            before do
              sign_in user
              get :activity, params: { id: page.id, activity_id: page.versions.last.id }
            end

            it { expect(response.status).to eq 200 }
          end
        end
      end
    end
  end
end
