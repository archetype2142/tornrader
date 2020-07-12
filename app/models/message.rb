class Message < ApplicationRecord
  belongs_to :user

  validates :message, presence: true, allow_blank: false
end