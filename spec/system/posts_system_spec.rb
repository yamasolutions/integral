require "rails_helper"

module Integral
  describe "Post CRUD", type: :system do
    let!(:post) { create(:integral_post) }
    let(:builder) { build(:integral_post) }

    before do
      sign_in(create(:post_manager))
    end

    it "can view the posts dashboard" do
      visit backend_posts_path

      expect(page).to have_content 'Posts'
    end

    it "can view the posts list" do
      visit list_backend_posts_path

      expect(page).to have_content 'Post Listing'
    end

    it "can view a post" do
      visit backend_post_path(post)

      expect(page).to have_content post.title
    end

    it "can create a post" do
      visit new_backend_post_path

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
      sleep 1

      expect(page).to have_content I18n.t('integral.backend.notifications.creation_success', type: Integral::Post.model_name.human)
    end

    it "can update a post" do
      visit edit_backend_post_path(post)

      within("#resource_form") do
        fill_in 'Title', with: builder.title
        fill_in 'Description', with: builder.description

        fill_in_ckeditor 'resource_body_editor', with: builder.body
      end

      first(:button, 'Update Post').click
      sleep 1

      expect(page).to have_content I18n.t('integral.backend.notifications.edit_success', type: Integral::Post.model_name.human)
    end

    it "can delete a post" do
      visit backend_post_path(post)

      click_on 'Delete'
      click_on 'Confirm'

      expect(page).to have_content I18n.t('integral.backend.notifications.delete_success', type: Integral::Post.model_name.human)
    end
  end
end
