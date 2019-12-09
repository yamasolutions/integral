require 'rails_helper'

module Integral
  describe "User CRUD", :type => :feature do
    let!(:user) { create(:user) }
    let(:builder) { build(:user) }

    before do
      sign_in(create(:user_manager))

      within(".app-dashboard-sidebar-inner li.is-dropdown-submenu-parent") do
        click_on 'Users'
        click_on 'Dashboard'
      end
    end

    it "can create a user" do
      within(".card.listing") do
        click_on 'Create'
      end

      within("#user_form") do
        fill_in 'Name', with: builder.name
        fill_in 'Email', with: builder.email
      end

      click_on 'Invite User'

      expect(page).to have_content I18n.t('integral.backend.notifications.creation_success', type: Integral::User.model_name.human)
      expect(page).to have_content builder.name
      expect(page).to have_content builder.email
    end

    it "can update a user" do
      sleep 1
      find('tbody tr:first-of-type a:nth-of-type(2)').click

      within("#user_form") do
        fill_in 'Name', with: builder.name
        fill_in 'Email', with: builder.email
      end

      click_on 'Update User'

      expect(page).to have_content I18n.t('integral.backend.notifications.edit_success', type: Integral::User.model_name.human)
      expect(page).to have_content builder.name
      expect(page).to have_content builder.email
    end

    it "can delete a user" do
      sleep 1
      find('tbody tr:nth-of-type(2) a:nth-of-type(3)').click
      all('.reveal.dialog a')[1].click

      expect(page).to have_content I18n.t('integral.backend.notifications.delete_success', type: Integral::User.model_name.human)
    end

    it "can view a user" do
      sleep 1
      find('tbody tr:first-of-type a:nth-of-type(2)').trigger 'click'

      expect(page).to have_content user.name
      expect(page).to have_content user.email
    end
  end
end
