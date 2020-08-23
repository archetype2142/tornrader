class CreateLineItemPrice < ActiveRecord::Migration[6.0]
  def change
    create_table :line_item_prices do |t|
      t.references :price, index: true
      t.references :line_item, index: true
    end

    # Trade.all.each do |trade|
    #   trade.line_items.each do |li|
    #     li.prices
    #   end
    # end
  end
end
