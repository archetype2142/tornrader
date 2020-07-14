class AddPricingRuleAndAmountToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pricing_rule, :integer, default: 0
    add_column :users, :amount, :integer
  end
end
