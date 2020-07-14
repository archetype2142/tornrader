class AddPricingRuleToPrice < ActiveRecord::Migration[6.0]
  def change
    add_column :prices, :pricing_rule, :integer, default: 0
  end
end
