class AddTotalToTrade < ActiveRecord::Migration[6.0]
  def change
    add_column :trades, :total, :integer, default: 0
  end
end
