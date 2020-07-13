class AddApiTokenTimestampToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :trader_api_token_update_at, :datetime
  end
end
