FactoryGirl.define do
  factory :ipl do
    price { Random.rand(10.0) }
    name { Faker::Food.ingredient }
  end
end