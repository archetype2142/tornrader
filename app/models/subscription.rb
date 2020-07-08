class Subscription < ApplicationRecord
  belongs_to :user

  enum state: %w[active inactive]
end