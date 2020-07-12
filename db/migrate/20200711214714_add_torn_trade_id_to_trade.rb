class AddTornTradeIdToTrade < ActiveRecord::Migration[6.0]
  def change
    add_column :trades, :torn_trade_id, :integer, index: :true
  end
end
