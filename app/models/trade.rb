class Trade < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: :slugged

  belongs_to :user, counter_cache: true
  has_many :line_items, dependent: :destroy
  has_many :items, through: :line_items

  scope :total_sum, -> {
    self.all.map{ |t| t.total }.sum
  }
  
  before_create do 
    self.slug = SecureRandom.uuid
  end

  def update_total
    total_price = self.line_items.pluck(:total).sum
    total_profit = self.line_items.pluck(:profit).sum
    self.update!(total: total_price, profit: total_profit) unless self.total == total_price
  end

  def normalize_friendly_id(value)
    value.to_s.parameterize(preserve_case: true)
  end
end