class AddApiTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :trader_api_token, :string
  end
end
