class AddAveragePriceToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :average_market_price, :bigint, default: 0
  end
end
