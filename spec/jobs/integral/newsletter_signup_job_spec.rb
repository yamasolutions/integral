require 'rails_helper'

module Integral
  describe NewsletterSignupJob do
    let(:signup) { NewsletterSignup.create!(email: 'foo@bar.com') }

    context 'when API is not available' do
      it 'does nothing' do
        expect(described_class.perform_now(signup)).to eq nil
      end
    end

    context 'when API is available' do
      before do
        allow(NewsletterSignup).to receive(:api_available?).and_return(true)
      end

      context 'when an error occurs' do
        it 'does not update the signup instance' do
          allow(Gibbon::Request).to receive(:new).and_raise(Gibbon::MailChimpError)

          expect { described_class.perform_now(signup) }.not_to change(signup, :processed)
        end
      end

      context 'when no error occurs' do
        let(:gibbon_request) { double() }
        it 'updates the signup instance' do
          allow(gibbon_request).to receive_message_chain("lists.members.create")
          allow(Gibbon::Request).to receive(:new).and_return(gibbon_request)

          expect { described_class.perform_now(signup) }.to change(signup, :processed)
        end
      end
    end
  end
end
