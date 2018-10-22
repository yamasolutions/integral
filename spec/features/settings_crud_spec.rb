require 'rails_helper'

module Integral
  describe "Settings CRUD", :type => :feature do

    before do
      sign_in(create(:user_manager))
      # click_on 'Pages'
    end

    xit "can visit the settings page" do
      # expect(page).to have_content I18n.t('integral.backend.pages.notification.creation_success')
    end

    it "can update a setting" do
      # within("#page_form") do
      #   fill_in 'Title', with: builder.title
      #   fill_in 'Description', with: builder.description
      #   fill_in 'Path', with: builder.path
      #
      #   fill_in_ckeditor 'content_editor', with: builder.body
      # end

      # click_on 'Update Page'
      #
      # expect(page).to have_content I18n.t('integral.backend.pages.notification.edit_success')
    end
  end
end
