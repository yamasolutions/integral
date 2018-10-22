require 'rails_helper'

module Integral
  module Backend
    describe BaseController do
      routes { Integral::Engine.routes }

      controller do
        def after_sign_in_path_for(resource)
          super resource
        end

        def index
          raise Pundit::NotAuthorizedError
        end
      end

      let(:user) { create(:user) }

      describe "after sigin-in" do
        it "redirects to user dashboard" do
          expect(controller.after_sign_in_path_for(user)).to eq Engine.routes.url_helpers.backend_dashboard_path
        end
      end

      describe "layout_by_resource" do
        context 'when devise controller' do
          before do
            allow(subject).to receive(:devise_controller?).and_return true
          end

          it 'renders custom devise layout' do
            expect(controller.send(controller.class.send(:_layout))).to eq 'integral/login'
          end
        end

        context 'when not devise controller' do
          it 'renders standard layout' do
            expect(controller.send(controller.class.send(:_layout))).to eq 'integral/backend'
          end
        end
      end
    end
  end
end
