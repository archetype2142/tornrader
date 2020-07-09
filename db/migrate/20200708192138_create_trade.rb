class CreateTrade < ActiveRecord::Migration[6.0]
  def change
    create_table :trades do |t|
      t.timestamps
      t.references :user
    end
  end
end
