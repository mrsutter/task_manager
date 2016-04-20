FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { password }

    trait :admin do
      role 'admin'
    end

    trait :with_task do
      after(:create) do |user|
        create(:task, user: user)
      end
    end

    trait :with_tasks do
      after(:create) do |user|
        5.times do
          create(:task, user: user)
        end
      end
    end
  end
end
