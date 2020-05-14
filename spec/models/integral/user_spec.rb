require 'rails_helper'

module Integral
  describe User, type: :model do
    let(:user) { build(:user) }

    it 'has a valid factory' do
      expect(user.valid?).to be true
    end

    it "enables paper trail" do
      is_expected.to be_versioned
    end

    describe 'relations' do
      it { is_expected.to have_many :role_assignments }
      it { is_expected.to have_many(:roles).through :role_assignments }
    end

    describe 'validates' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_length_of(:name).is_at_least(3) }
      it { is_expected.to validate_length_of(:name).is_at_most(25) }

      it { is_expected.to validate_presence_of :email }
    end

    describe '.integral_icon' do
      it 'returns expected icon' do
        expect(described_class.integral_icon).to eq 'user'
      end
    end

    describe '#role?' do
      let(:role) { create(:role) }

      context 'when the role does not exist' do
        it 'returns false' do
          expect(user.role?(role)).to eq false
        end
      end

      context 'when the role exists' do
        before do
          user.roles << role
        end

        it 'returns true' do
          expect(user.role?(role.name.to_sym)).to eq true
        end
      end
    end
  end
end
