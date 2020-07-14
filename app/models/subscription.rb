class Subscription < ApplicationRecord
  belongs_to :user

  enum state: %w[active inactive]
  enum pricelist_type: %w[manual auto]
end