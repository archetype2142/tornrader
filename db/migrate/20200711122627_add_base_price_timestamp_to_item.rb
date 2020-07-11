class AddBasePriceTimestampToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :base_price_added_on, :datetime
  end
end
