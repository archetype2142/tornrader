class Position < ApplicationRecord
  belongs_to :user
  belongs_to :category

  enum auto_update: %w[auto_updated_not auto_updated]
end