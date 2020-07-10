class AddUpdatedPriceListAtToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :updated_price_list_at, :datetime
  end
end
