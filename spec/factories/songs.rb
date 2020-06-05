FactoryBot.define do
  factory :song do
    name {FFaker::Lorem.characters(rand(3..20))}
    description {FFaker::Lorem.characters(rand(3..20))}
    artist {FFaker::Music.artist}
    association :user
    association :category
  end
end
