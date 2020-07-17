class AddShortPricelistUrlToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :short_pricelist_url, :string
  end
end
