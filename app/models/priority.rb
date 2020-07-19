class Priority < ApplicationRecord
  has_one :category
  belongs_to :priority_list
end