require 'rails_helper'

module Integral
  describe "Post CRUD", :type => :feature do
    let!(:image) { create(:image) }
    let!(:post) { create(:integral_post) }
    let(:builder) { build(:integral_post) }

    before do
      sign_in(create(:post_manager))
      within(".app-dashboard-sidebar-inner li.is-dropdown-submenu-parent") do
        click_on 'Posts'
        click_on 'Dashboard'
      end
    end

    it "can create a post" do
      within(".card.listing") do
        click_on 'Create'
      end

      fill_in 'Title', with: builder.title
      fill_in 'Description', with: builder.description
      # # Select first image in ImageSelector
      # # TODO: Make this into helper
      # find('label[for=post_image]').click
      # sleep(1)
      # first('.image-selector .record-selector .records .record').click
      # find('.image-selector .record-selector .modal-footer .close-button').click

      fill_in_ckeditor 'resource_body_editor', with: builder.body

      click_on 'Create Post'

      expect(page).to have_content I18n.t('integral.backend.notifications.creation_success', type: Integral::Post.model_name.human)
    end

    it "can update a post" do
      sleep 1
      find('tbody tr:first-of-type a:nth-of-type(2)').click

      within("#resource_form") do
        fill_in 'Title', with: builder.title
        fill_in 'Description', with: builder.description

        fill_in_ckeditor 'resource_body_editor', with: builder.body
      end

      first(:button, 'Update Post').click

      expect(page).to have_content I18n.t('integral.backend.notifications.edit_success', type: Integral::Post.model_name.human)
    end

    it "can delete a post" do
      sleep 1
      find('tbody tr:first-of-type a:nth-of-type(3)').click
      all('.reveal.dialog a')[1].click

      expect(page).to have_content I18n.t('integral.backend.notifications.delete_success', type: Integral::Post.model_name.human)
    end

    # it "can view a post" do
    #   sleep 1
    #   all('tbody tr.odd a')[0].trigger 'click'
    #
    #   expect(page).to have_content post.title
    # end
  end
end
