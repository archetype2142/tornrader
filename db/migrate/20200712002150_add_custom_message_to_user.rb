class AddCustomMessageToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :custom_message, :string
  end
end
