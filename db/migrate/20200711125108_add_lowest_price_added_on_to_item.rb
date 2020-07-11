class AddLowestPriceAddedOnToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :lowest_price_added_on, :datetime
  end
end
