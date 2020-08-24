class AddProfitToLineItemAndTrade < ActiveRecord::Migration[6.0]
  def change
    add_column :line_items, :profit, :bigint, default: 0
    add_column :trades, :profit, :bigint, default: 0    
  end
end
