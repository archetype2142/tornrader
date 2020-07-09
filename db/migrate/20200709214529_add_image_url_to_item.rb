class AddImageUrlToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :image_url, :string, default: :null
    add_column :items, :description, :string, default: :null
  end
end
