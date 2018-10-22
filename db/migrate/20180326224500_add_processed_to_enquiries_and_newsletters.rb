class AddProcessedToEnquiriesAndNewsletters < ActiveRecord::Migration[5.1]
  def change
    add_column :integral_enquiries, :processed, :boolean, default: false
    add_column :integral_newsletter_signups, :processed, :boolean, default: false
  end
end
