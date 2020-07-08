class AddItemsToCategories < ActiveRecord::Migration[6.0]
  def change
    add_reference :items, :category, index: true
  end
end
