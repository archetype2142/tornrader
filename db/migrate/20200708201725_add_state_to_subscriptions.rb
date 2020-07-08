class AddStateToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :state, :integer, default: 0
  end
end
