class AddTornApiKeyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :torn_api_key, :string
    add_column :users,:torn_user_id, :string
  end
end
