require 'rails_helper'

module Integral
  module Notification
    describe NotificationDecorator do
      let(:notification) { create(:integral_notification, action: 'update') }

      subject { described_class.new(notification) }

      describe '#formatted_action' do
        it 'provides the formatted action' do
          expect(subject.formatted_action).to eq 'Update'
        end
      end

      describe '#action_verb' do
        it 'provides the formatted action verb' do
          expect(subject.action_verb).to eq 'Updated'
        end
      end
    end
  end
end
