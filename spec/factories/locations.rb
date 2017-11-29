FactoryGirl.define do
  factory :location do
    name { Faker::Space.planet }
    lat { Random.rand(53.0) }
    lng { Random.rand(53.0) }
    vicinity { Faker::Address.street_address }
    googleid { Faker::Address.secondary_address }
  end
end