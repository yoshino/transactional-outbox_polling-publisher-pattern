FactoryBot.define do
  factory :order do
    status { ['preparing', 'ready'].sample }
  end
end
