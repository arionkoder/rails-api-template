FactoryBot.define do
  factory :user do
    name { "Gustavo" }
    email { Faker::Internet.email(domain: 'gmail') }
    password { "123123123"}
  end
end
