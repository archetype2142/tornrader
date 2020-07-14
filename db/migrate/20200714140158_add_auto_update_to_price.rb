class AddAutoUpdateToPrice < ActiveRecord::Migration[6.0]
  def change
    add_column :prices, :auto_update, :integer, default: 0
  end
end
