FactoryBot.define do
  factory :album do
    name {FFaker::Lorem.characters(rand(3..255))}
  end
end
