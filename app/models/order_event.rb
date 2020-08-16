class OrderEvent < ApplicationRecord
  enum event_type: { post_order: 0, put_order: 1, delete_order: 2 }

  validates :event_type, presence: true
  validates :order_status, presence: true
end
