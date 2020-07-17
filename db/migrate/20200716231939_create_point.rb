class CreatePoint < ActiveRecord::Migration[6.0]
  def change
    create_table :points do |t|
      t.timestamps
      t.integer :price
    end
  end
end
