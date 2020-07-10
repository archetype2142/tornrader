class AddThumbnailUrlToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :thumbnail_url, :string
  end
end
