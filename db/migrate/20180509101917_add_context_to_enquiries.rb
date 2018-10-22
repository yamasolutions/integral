class AddContextToEnquiries < ActiveRecord::Migration[5.1]
  def change
    add_column :integral_enquiries, :newsletter_opt_in, :boolean, default: true
    add_column :integral_enquiries, :context, :string
  end
end
