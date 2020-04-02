require 'rails_helper'

module Integral
  describe "the signin process", type: :system do
    it "signs a user in" do
      sign_in

      expect(page).to have_content 'Dashboard'
    end

     it "signs a user out" do
      sign_in
      sign_out

      not_logged_in_message = 'You need to sign in or sign up before continuing'
      expect(page).to have_content not_logged_in_message
    end
  end
end
