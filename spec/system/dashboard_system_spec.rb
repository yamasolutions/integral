require "rails_helper"

describe "Dashboard", type: :system do
  it "loads successfully" do
    sign_in(create(:post_manager))
    
    expect(page).to have_text("Dashboard")
  end
end
