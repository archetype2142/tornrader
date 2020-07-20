class Price < ApplicationRecord
  belongs_to :item
  belongs_to :user, touch: true
  belongs_to :line_item, optional: true

  validates :item_id, uniqueness: { scope: :user_id }

  enum auto_update: %w[auto_updated_not auto_updated]
  enum pricing_rules: %w[percentage fixed]
  # validates :amount, numericality: { only_integer: true, greater_than: 0 }
end

# PRICEDEDUPE
# User.all.each do |u|
#   dups = u.prices.group(:item_id).having('count("item_id") > 1').count

#   dups.each do |key, value|
#     duplicates = u.prices.where(item_id: key)[1..value-1]
#     puts "#{key} = #{duplicates.count}"
#     duplicates.each(&:destroy)
#   end
# end