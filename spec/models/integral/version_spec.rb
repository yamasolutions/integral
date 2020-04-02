require 'rails_helper'

module Integral
  describe Version do
    let(:available_objects) { [["Post", Integral::Post], ["Category", Integral::Category], ["Page", Integral::Page], ["List", Integral::List], ["Image", Integral::Image],["User", Integral::User]]}
    let(:available_actions) { [["Update", "update"], ["Create", "create"], ["Delete", "destroy"], ["Publish", "publish"]] }

    describe '.available_objects' do
      it 'returns array with readable object names and object' do
        expect(described_class.available_objects).to eq available_objects
      end
    end

    describe '.available_actions' do
      it 'returns array with readable actions' do
        expect(described_class.available_actions).to eq available_actions
      end
    end
  end
end
