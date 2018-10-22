require 'rails_helper'

module Integral
  describe Role, type: :model do
    let(:role) { build(:role) }

    it 'has a valid factory' do
      expect(role.valid?).to be true
    end

    describe 'relations' do
      it { is_expected.to have_many :role_assignments }
      it { is_expected.to have_many(:users).through(:role_assignments) }
    end

    describe 'validates' do
      it { is_expected.to validate_presence_of :name }
    end

    describe '#label' do
      it 'returns expected label' do
        subject.name = 'fooBar'

        expect(subject.label).to eq I18n.t("integral.backend.roles.labels.foo_bar")
      end
    end
  end
end
