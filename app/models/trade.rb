class Trade < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: :slugged

  belongs_to :user, optional: true
  has_many :line_items
  has_many :items, through: :line_items

  before_create do 
    self.slug = SecureRandom.uuid
  end

  def total
    self.line_items.map { |li| li.items.last.price * li.quantity }.sum
  end
end