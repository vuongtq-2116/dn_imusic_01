FactoryBot.define do
  factory :album do
    name {FFaker::Lorem.characters(rand(3..255))}
    album_songs_attributes {attributes_for(:album_song)}
  end
end
