class Order < ApplicationRecord
  has_many :order_events
  enum status: { preparing: 0, ready: 1 }

  validates :status, presence: true
end
