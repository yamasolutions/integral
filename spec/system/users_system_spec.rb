require "rails_helper"

module Integral
  describe "User CRUD", type: :system do
    let!(:user) { create(:integral_user) }
    let(:builder) { build(:integral_user) }

    before do
      sign_in(create(:user_manager))
    end

    it "can view the users dashboard" do
      visit backend_users_path

      expect(page).to have_content 'Users'
    end

    xit "can view the users list" do
      visit list_backend_users_path

      expect(page).to have_content 'User Listing'
    end

    it "can view a user" do
      visit backend_user_path(user)

      expect(page).to have_content user.name
    end

    it "can create a user" do
      visit new_backend_user_path

      fill_in 'Name', with: builder.name
      fill_in 'Email', with: builder.email

      click_on 'Invite User'
      sleep 1

      expect(page).to have_content I18n.t('integral.backend.notifications.creation_success', type: Integral::User.model_name.human)
    end

    it "can update a user" do
      visit edit_backend_user_path(user)

      fill_in 'Name', with: builder.name
      fill_in 'Email', with: builder.email

      first(:button, 'Update User').click
      sleep 1

      expect(page).to have_content I18n.t('integral.backend.notifications.edit_success', type: Integral::User.model_name.human)
    end

    it "can delete a user" do
      visit backend_users_path

      find('tbody tr:nth-of-type(2) a:nth-of-type(3)').click

      click_on 'Confirm'

      expect(page).to have_content I18n.t('integral.backend.notifications.delete_success', type: Integral::User.model_name.human)
    end
  end
end
