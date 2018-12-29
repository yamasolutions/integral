require 'rails_helper'

module Integral
  describe UserDecorator do
    let(:user) { create(:user) }

    subject { described_class.new(user) }

    describe '#backend_url' do
      it 'provides the correct URL' do
        expect(subject.backend_url).to eq "http://test.somehost.com/admin/users/#{user.id}"
      end
    end
  end
end
