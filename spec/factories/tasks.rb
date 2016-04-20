FactoryGirl.define do
  factory :task do
    name { Faker::Name.name }
    description { Faker::Hipster.paragraph }
    user
  end
end
