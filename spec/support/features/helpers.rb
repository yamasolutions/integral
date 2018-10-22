module Features
  module Helpers

    # Signs a user in
    # @param user [Integral::User] user to sign in
    def sign_in(user=create(:user))
      visit new_user_session_path

      within("#new_user") do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
      end

      click_button 'Log in'
    end

    # Signs the currently logged in user out
    def sign_out
      find('button.avatar').hover
      # Ideally shouldn't have to pass visible: false here but doesn't work otherwise (?)
      find('a.button.hollow', text: 'Logout', visible: false).click
    end

    # Fills in CKeditor
    #
    # Example usage:
    # fill_in_ckeditor 'email_body', :with => 'This is my message!'
    #
    # @param locator [String] Used to locate the editor
    # @param opts [Hash] contains what to fill the editor with and other options (See Capybara docs)
    def fill_in_ckeditor(locator, opts)
      sleep 1
      content = opts.fetch(:with).to_json
      page.execute_script <<-SCRIPT
              CKEDITOR.instances['#{locator}'].setData(#{content});
                                                           $('textarea##{locator}').text(#{content});
      SCRIPT
    end
  end
end
