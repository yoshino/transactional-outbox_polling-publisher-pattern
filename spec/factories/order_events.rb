FactoryBot.define do
  factory :order_event do
    event_type { ['post_order', 'put_order', 'delete_order'].sample }
    order_id { 1 }
    order_status { ['preparing', 'ready'].sample }
  end
end
