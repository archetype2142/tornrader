class AddAutoUpdatedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :auto_update, :integer, default: 0
  end
end
