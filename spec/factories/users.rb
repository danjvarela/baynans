FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example"
  end

  factory :user do
    email { generate :email }
    password { "password" }
  end
end
