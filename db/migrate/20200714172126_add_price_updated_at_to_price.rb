class AddPriceUpdatedAtToPrice < ActiveRecord::Migration[6.0]
  def change
    add_column :prices, :price_updated_at, :datetime
  end
end
