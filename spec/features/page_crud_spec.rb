require 'rails_helper'

module Integral
  describe "Page CRUD", :type => :feature do
    let!(:integral_page) { create(:integral_page) }
    let(:builder) { build(:integral_page) }

    before do
      sign_in(create(:page_manager))
      within(".app-dashboard-sidebar-inner li.is-dropdown-submenu-parent") do
        click_on 'Pages'
        click_on 'Dashboard'
      end
    end

    it "can create a page" do
      within(".card.listing") do
        click_on 'Create'
      end

      within("#page_form") do
        fill_in 'Title', with: builder.title
        fill_in 'Description', with: builder.description
        fill_in 'Path', with: builder.path

        fill_in_ckeditor 'page_body_editor', with: builder.body
      end

      click_on 'Create Page'

      expect(page).to have_content I18n.t('integral.backend.pages.notification.creation_success')
    end

    it "can update a page" do
      sleep 1
      find('tbody tr:first-of-type a:nth-of-type(2)').click

      within("#page_form") do
        fill_in 'Title', with: builder.title
        fill_in 'Description', with: builder.description
        fill_in 'Path', with: builder.path

        fill_in_ckeditor 'page_body_editor', with: builder.body
      end

      first(:button, 'Update Page').click

      expect(page).to have_content I18n.t('integral.backend.pages.notification.edit_success')
    end

    it "can delete a page" do
      sleep 1
      find('tbody tr:first-of-type a:nth-of-type(3)').click
      all('.reveal.dialog a')[1].click

      expect(page).to have_content I18n.t('integral.backend.pages.notification.delete_success')
    end

    # it "can view a page" do
    #   sleep 1
    #   all('tbody tr.odd a')[0].trigger 'click'
    #
    #   expect(page).to have_content page.title
    # end
  end
end
