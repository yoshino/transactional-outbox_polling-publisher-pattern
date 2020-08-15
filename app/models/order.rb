class Order < ApplicationRecord
  enum status: { preparing: 0, ready: 1 }

  validates :status, presence: true
end
