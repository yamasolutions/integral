require 'rails_helper'

module Integral
  describe CategoriesController do
    routes { Integral::Engine.routes }

    let!(:resource) { create(:integral_category) }
    let!(:post) { create(:integral_post, category: resource, status: 1) }

    describe 'GET show' do
      before do
        get :show, params: { id: resource.to_param, integral_original_path: category_path(resource.to_param) }
      end

      it { expect(response.status).to eq 200 }
      it { expect(response).to render_template 'show' }
    end
  end
end
