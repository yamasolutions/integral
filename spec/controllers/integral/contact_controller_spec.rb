require 'rails_helper'

module Integral
  describe ContactController do
    routes { Integral::Engine.routes }

    let(:contact_params) { { name: 'Mr Foo Bar', email: 'foo@bar.com', message: 'Some message', subject: 'Some subject' } }

    describe 'POST contact' do
      context 'when valid contact params supplied' do
        before do
          expect(ContactMailer).to receive(:forward_enquiry).and_return(double(deliver_later: nil))
          expect(ContactMailer).to receive(:auto_reply).and_return(double(deliver_later: nil))
        end

        it 'returns status created' do
          post :contact, params: { enquiry: contact_params }

          expect(response.code).to eq "201"
        end

        it 'saves a new enquiry' do
          expect {
            post :contact, params: { enquiry: contact_params }
          }.to change(Integral::Enquiry, :count).by(1)
        end
      end

      context 'when invalid contact params supplied' do
        it 'does not save a new enquiry' do
          expect {
            post :contact, params: { enquiry: contact_params.merge!(email: '') }
          }.not_to change(Integral::Enquiry, :count)
        end

        it 'returns status unprocessable_entity' do
          post :contact, params: { enquiry: contact_params.merge!(email: '') }

          expect(response.code).to eq "422"
        end
      end
    end
  end
end
