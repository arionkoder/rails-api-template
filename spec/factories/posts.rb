FactoryBot.define do
  factory :post do
    title { "FirstPost" }
    published { false }
    content { "FirstContent" }
    association :user, factory: :user

    trait :published do
      published { true }
    end
  end
end
