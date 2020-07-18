class AddCategoryToPrices < ActiveRecord::Migration[6.0]
  def change
    add_reference :prices, :category, index: true
  end
end
