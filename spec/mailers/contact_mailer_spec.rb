require 'rails_helper'

module Integral
  describe ContactMailer do
    let(:enquiry) { create(:integral_enquiry) }

    before do
      Integral::Settings.contact_email = 'foo@bar.com'
    end

    describe 'forward_enquiry' do
      let(:mail) { described_class.forward_enquiry(enquiry).deliver_now }

      it 'renders the subject' do
        # expect(mail.subject).to eq "#{enquiry.reference} #{I18n.t('integral.contact_mailer.forward_enquiry.subject')}"
        expect(mail.subject).to eq "#{enquiry.reference} #{I18n.t('integral.contact_mailer.forward_enquiry.subject')} - #{enquiry.subject}"
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq [Integral::Settings.contact_email]
      end

      it 'renders the sender email' do
        expect(mail.from).to eq [enquiry.email]
      end
    end

    describe 'auto_reply' do
      let(:mail) { described_class.auto_reply(enquiry).deliver_now }

      it 'renders the subject' do
        expect(mail.subject).to eq I18n.t('integral.contact_mailer.auto_reply.subject', reference: enquiry.reference)
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq [enquiry.email]
      end

      it 'renders the sender email' do
        expect(mail.from).to eq [Integral::Settings.contact_email]
      end
    end
  end
end
