class AddLineitemToPrice < ActiveRecord::Migration[6.0]
  def change
    add_reference :prices, :line_item, index: true
  end
end
