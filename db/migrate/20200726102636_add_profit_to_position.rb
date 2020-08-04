class AddProfitToPosition < ActiveRecord::Migration[6.0]
  def change
    add_column :positions, :auto_update, :integer, default: 0
    add_column :positions, :amount, :integer, default: 0
  end
end
