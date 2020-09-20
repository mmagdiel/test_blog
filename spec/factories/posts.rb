FactoryBot.define do
  factory :post do
    title { "MyString" }
    content { "MyString" }
    published { false }
    user { nil }
  end
end
