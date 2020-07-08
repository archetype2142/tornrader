class CreateSubscription < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.timestamps
      t.datetime :ends_at, null: false
    end
  end
end
