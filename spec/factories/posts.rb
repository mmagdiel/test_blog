FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { rand(0..1) == 0 ? false : true }
    user
  end
end
