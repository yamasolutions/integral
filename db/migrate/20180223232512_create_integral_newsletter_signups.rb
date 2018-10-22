class CreateIntegralNewsletterSignups < ActiveRecord::Migration[5.1]
  def change
    create_table :integral_newsletter_signups do |t|
      t.string :email
      t.string :name
      t.string :context

      t.timestamps null: false
    end
  end
end
