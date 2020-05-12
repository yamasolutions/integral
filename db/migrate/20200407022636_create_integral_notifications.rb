class CreateIntegralNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :integral_users, :notify_me, :boolean, default: true

    create_table :integral_notifications do |t|
      t.integer :recipient_id
      t.integer :actor_id
      t.datetime :read_at
      t.string :action
      # (automated index name is too long)
      t.references :subscribable, polymorphic: true, index: { name: 'index_integral_notifications_on_subscribable_type_id' }

      t.timestamps null: false
    end

    create_table :integral_notification_subscriptions do |t|
      t.integer :user_id
      t.string :state
      # (automated index name is too long)
      t.references :subscribable, polymorphic: true, index: { name: 'index_integral_subscriptions_on_subscribable_type_id' }

      t.timestamps null: false
    end
  end
end
