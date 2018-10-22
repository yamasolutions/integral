require "rails_helper"

module Integral
  module Middleware
    describe PageRouter do
      let(:path) { 'some/url/path' }
      let(:request) { double('get?' => true, 'path_info' => path ) }
      let(:app) { double('call' => true ) }
      let(:env) { {} }

      subject { described_class.new(app) }

      before do
        allow(Rack::Request).to receive(:new).and_return(request)
      end

      describe 'GET Request' do
        it 'returns early' do
          expect(app).to receive(:call).with(env)
          expect(Integral).not_to receive(:dynamic_homepage_enabled?)
          # expect path to not have changed

          subject.call(env)
        end
      end

      describe 'homepage request' do
        let(:path) { '/' }

        context 'homepage is nil' do
          # and calls logger?
          it 'does not modify path' do
            expect(app).to receive(:call).with(env)
            subject.call(env)
          end
        end

        context 'homepage exists' do
          it 'modifies path to homepage' do
            expect(app).to receive(:call).with(env)
            subject.call(env)
          end
        end
      end

      describe 'rewrite throws an exception' do
        it 'is handled'
      end

      describe 'normal page request' do
        it 'does not modify path'
      end

      describe 'dynamic page request' do
        it 'modifies path'
      end
    end
  end
end
