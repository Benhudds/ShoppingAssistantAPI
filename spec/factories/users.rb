FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }#'foo@bar.com'
    password 'foobar'
  end
end