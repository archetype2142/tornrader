class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :torn_id
      t.string :name
      t.integer :price
    end
  end
end
