require 'rails_helper'

module Integral
  describe RoleAssignment, type: :model do
    describe 'relations' do
      it { is_expected.to belong_to :user }
      it { is_expected.to belong_to :role }
    end
  end
end
