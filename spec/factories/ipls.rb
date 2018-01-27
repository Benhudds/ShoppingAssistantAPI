FactoryGirl.define do
  factory :ipl do
    price { Random.rand(10.0) }
    item { Faker::Food.ingredient }
    quantity { Random.rand(10.0) }
    measure { Faker::Food.metric_measurement }
  end
end