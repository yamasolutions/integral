require 'rails_helper'

module Integral
  describe PostsController do
    routes { Integral::Engine.routes }

    let!(:resource) { create(:integral_post, status: 1) }

    describe 'GET index' do
      before do
        get :index
      end

      it { expect(response.status).to eq 200 }
      it { expect(response).to render_template 'index' }
    end

    describe 'GET show' do
      before do
        get :show, params: { id: resource.to_param }
      end

      it { expect(response.status).to eq 200 }
      it { expect(response).to render_template 'integral/posts/templates/default' }
    end
  end
end
