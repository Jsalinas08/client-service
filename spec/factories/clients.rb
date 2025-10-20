FactoryBot.define do
  factory :client do
    name { "John Doe" }
    address { "123 Main St" }
    sequence(:dni) { |n| "DNI#{n.to_s.rjust(8, '0')}" }
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
