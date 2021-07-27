require 'rails_helper'

module Integral
  describe Version do
    let(:available_objects) { [["User", Integral::User], ["List", Integral::List], ["Page", Integral::Page], ["Post", Integral::Post], ["Category", Integral::Category], ["File", Integral::Storage::File]] }
    let(:available_actions) { [["Update", "update"], ["Create", "create"], ["Delete", "destroy"], ["Publish", "publish"]] }

    describe '.available_objects' do
      it 'returns array with readable object names and object' do
        expect(described_class.available_objects).to match_array available_objects
      end
    end

    describe '.available_actions' do
      it 'returns array with readable actions' do
        expect(described_class.available_actions).to match_array available_actions
      end
    end
  end
end
