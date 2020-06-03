FactoryBot.define do
  factory :category do
    name {FFaker::Lorem.characters(rand(3..20))}
  end
end
