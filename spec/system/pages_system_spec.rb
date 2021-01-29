require "rails_helper"

module Integral
  describe "Page CRUD", type: :system do
    let!(:resource) { create(:integral_page) }
    let(:builder) { build(:integral_page) }

    before do
      sign_in(create(:page_manager))
    end

    it "can view the pages dashboard" do
      visit backend_pages_path

      expect(page).to have_content 'Pages'
    end

    it "can view the pages list" do
      visit list_backend_pages_path

      expect(page).to have_content 'Page Listing'
    end

    it "can view a page" do
      visit backend_page_path(resource)

      expect(page).to have_content resource.title
    end

    it "can create a page" do
      visit new_backend_page_path

      fill_in 'Title', with: builder.title
      fill_in 'Description', with: builder.description
      fill_in 'Path', with: builder.path

      click_on 'Create Page'
      sleep 1

      expect(page).to have_content I18n.t('integral.backend.notifications.creation_success', type: Integral::Page.model_name.human)
    end

    it "can update a page" do
      visit edit_backend_page_path(resource)

      within("#resource_form") do
        fill_in 'Title', with: builder.title
        fill_in 'Description', with: builder.description
      end

      first(:button, 'Update Page').click
      sleep 1

      expect(page).to have_content I18n.t('integral.backend.notifications.edit_success', type: Integral::Page.model_name.human)
    end

    it "can delete a page" do
      visit backend_page_path(resource)

      click_on 'Delete'
      click_on 'Confirm'

      expect(page).to have_content I18n.t('integral.backend.notifications.delete_success', type: Integral::Page.model_name.human)
    end
  end
end
