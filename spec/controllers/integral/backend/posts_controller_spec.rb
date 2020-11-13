require 'rails_helper'

module Integral
  module Backend
    describe PostsController do
      routes { Integral::Engine.routes }

      let(:title) { 'foobar title' }
      let(:slug) { 'foobar-title' }
      let(:body) { '<p>foobar body.</p>' }
      let(:description) { Faker::Lorem.paragraph(8)[0..150] }
      let(:tag_list) { 'foo,bar,tags' }
      let(:category) { create(:integral_category) }
      let(:post_params) { { title: title, body: body, description: description, tag_list: tag_list, slug: slug, user_id: user.id, category_id: category.id } }
      let(:user) { create(:post_manager) }
      let!(:user_post) { create(:integral_post) }

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
            get :index
          end

          it { expect(response.status).to eq 200 }
          it { expect(response).to render_template 'index' }
        end
      end

      describe 'POST create' do
        context 'when not logged in' do
          it 'redirects to login page' do
            post :create, params: { post: post_params }

            expect(response).to redirect_to new_user_session_path
          end
        end

        context 'when logged in' do
          before { sign_in user }

          context 'when valid post params supplied' do
            it 'redirects to the saved post' do
              post :create, params: { post: post_params }

              expect(response).to redirect_to edit_backend_post_path(assigns[:resource].id)
            end

            it 'saves a new post' do
              expect {
                post :create, params: { post: post_params }
              }.to change(Post, :count).by(1)
            end
          end

          context 'when invalid post params supplied' do
            it 'does not save a new post' do
              expect {
                post :create, params: { post: post_params.merge!(title: '') }
              }.not_to change(Post, :count)
            end

            it 'renders new template' do
              post :create, params: { post: post_params.merge!(title: '') }

              expect(response).to render_template("new")
            end
          end
        end
      end

      describe 'POST duplicate' do
        context 'when not logged in' do
          it 'redirects to login page' do
            post :duplicate, params: { id: user_post.id }

            expect(response).to redirect_to new_user_session_path
          end
        end

        context 'when logged in' do
          before { sign_in user }

          context 'when valid post params supplied' do
            it 'redirects to the cloned post' do
              post :duplicate, params: { id: user_post.id }

              expect(response).to redirect_to edit_backend_post_path(Integral::Post.last.id)
            end

            it 'saves a new post' do
              expect {
                post :duplicate, params: { id: user_post.id }
              }.to change(Post, :count).by(1)
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
            allow(Post).to receive(:new).and_return user_post
            get :new
          end

          it { expect(response.status).to eq 200 }
          it { expect(assigns(:resource)).to eq user_post }
          it { expect(assigns(:resource).user).to eq user }
          it { expect(response).to render_template 'new' }
        end
      end

      describe 'GET edit' do
        context 'when not logged in' do
          before do
            get :edit, params: { id: user_post.id }
        end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
            get :edit, params: { id: user_post.id }
          end

          it { expect(assigns[:resource]).to eq user_post }
          it { expect(response).to render_template 'edit' }
        end
      end

      describe 'PUT update' do
        context 'when not logged in' do
          before do
            put :update, params: { id: user_post.id, post: post_params }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
            put :update, params: { id: user_post.id, post: post_params }
            user_post.reload
          end

          context 'when valid parameters supplied' do
            it { expect(response).to redirect_to(edit_backend_post_path(user_post.id)) }
            it { expect(user_post.title).to eql title }
            it { expect(user_post.body).to eql body }
          end

          context 'when invalid parameters supplied' do
            let(:body) { '' }

            it { expect(user_post.title).not_to eql title }
            it { expect(user_post.body).not_to eql body }
            it { expect(response).to render_template 'edit' }
          end
        end
      end

      describe 'DELETE destroy' do
        context 'when not logged in' do
          before do
            delete :destroy, params: { id: user_post.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          before do
            sign_in user
            delete :destroy, params: { id: user_post.id }
          end

          it { expect(user_post.reload.deleted?).to be true }
          it { expect(response).to redirect_to backend_posts_path }
        end
      end

      describe 'GET activities' do
        let(:post) { create(:integral_post) }

        context 'when not logged in' do
          before do
            delete :activities, params: { id: post.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          context 'when user does not have required privileges' do
            let(:user) { create :user }

            before do
              sign_in user
              get :activities, params: { id: post.id }
            end

            it { expect(response.status).to eq 302 }
            it { expect(flash[:alert]).to eq I18n.t('errors.unauthorized') }
          end

          context 'when user has required privileges' do
            let(:user) { create :integral_admin_user }

            before do
              sign_in user
              get :activities, params: { id: post.id }
            end

            it { expect(response.status).to eq 200 }
          end
        end
      end

      describe 'GET activity', versioning: true do
        let!(:post) { create(:integral_post) }

        context 'when not logged in' do
          before do
            delete :activity, params: { id: post.id, activity_id: post.versions.last.id }
          end

          it { expect(response).to redirect_to new_user_session_path }
        end

        context 'when logged in' do
          context 'when user does not have required privileges' do
            let(:user) { create :user }

            before do
              sign_in user
              get :activity, params: { id: post.id, activity_id: post.versions.last.id }
            end

            it { expect(response.status).to eq 302 }
            it { expect(flash[:alert]).to eq I18n.t('errors.unauthorized') }
          end

          context 'when user has required privileges' do
            let(:user) { create :integral_admin_user }

            before do
              sign_in user
              get :activity, params: { id: post.id, activity_id: post.versions.last.id }
            end

            it { expect(response.status).to eq 200 }
          end
        end
      end
    end
  end
end
