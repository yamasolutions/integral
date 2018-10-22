require 'rails_helper'

module Integral
  describe PagesController do
    routes { Integral::Engine.routes }

    let!(:resource) { create(:integral_page, status: 1) }

    describe 'GET show' do
      context 'when post is published' do
        before do
          get :show, params: { id: resource.id }
        end

        it { expect(response.status).to eq 200 }
        it { expect(response).to render_template 'integral/pages/templates/default' }
      end

      context 'when post is draft' do
        let!(:resource) { create(:integral_page, status: 0) }
        let(:user) { create(:page_manager) }

        context 'a visitor cannot view the post' do
          it { expect{get :show, params: { id: resource.id }}.to raise_error(ActiveRecord::RecordNotFound) }
        end

        context 'a user can view the post' do
          before do
            sign_in user
            get :show, params: { id: resource.id }
          end

          it { expect(response.status).to eq 200 }
          it { expect(response).to render_template 'integral/pages/templates/default' }
        end
      end
    end
  end
end
