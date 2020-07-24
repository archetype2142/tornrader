class AddCustomThemeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :theme, :integer, default: 0
    add_column :users, :backgroundColor, :string
  end
end
