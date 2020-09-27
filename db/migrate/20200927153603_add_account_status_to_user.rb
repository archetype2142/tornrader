class AddAccountStatusToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :account_status, :integer, default: 0
  end
end
