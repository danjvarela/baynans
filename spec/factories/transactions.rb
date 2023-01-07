FactoryBot.define do
  factory :transaction do
    user { nil }
    stock { nil }
    amount { 1.5 }
    type { 1 }
  end
end
