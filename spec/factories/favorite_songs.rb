FactoryBot.define do
  factory :favorite_song do
    association :user
    association :song
  end
end
