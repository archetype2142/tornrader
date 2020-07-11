class AddLowestMarketPriceToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :lowest_market_price, :bigint, default: 0
  end
end
