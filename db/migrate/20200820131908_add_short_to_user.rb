class AddShortToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :short_url, :integer, default: 0
  end
end
