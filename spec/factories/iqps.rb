FactoryGirl.define do
  factory :iqp do
    item { Faker::StarWars.character }
    quantity { Random.rand(10) }
    measure { Faker::Food.metric_measurement }
  end
end