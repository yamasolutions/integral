require 'rails_helper'

module Integral
  describe UserPolicy do
    let(:manager) { create(:user_manager) }
    let(:user) { create(:user) }

    subject { described_class }

    permissions :manager?, :index?, :create?, :new?, :destroy? do
      context 'when user has user manager role' do
        it "grants access" do
          expect(subject).to permit(manager, user)
        end
      end

      context 'when user does not have user manager role' do
        it "does not grant access" do
          expect(subject).not_to permit(user, user)
        end
      end
    end

    permissions :update?, :edit?, :show? do
      context 'when user has user manager role' do
        it "grants access" do
          expect(subject).to permit(manager, user)
        end
      end

      context 'when user is same as instance' do
        it "grants access" do
          expect(subject).to permit(user, user)
        end
      end

      context 'when user does not have user manager role' do
        it "does not grant access" do
          expect(subject).not_to permit(user, manager)
        end
      end
    end
  end
end
