class CreateItemList < ActiveRecord::Migration[6.0]
  def change
    create_table :item_lists do |t|
      t.references :user
      t.references :item
    end
  end
end
