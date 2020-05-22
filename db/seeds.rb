# 10.times{
#   Category.create(name: FFaker::Music.genre)
# }

# 15.times do
#   Song.create name: FFaker::Music.song, category_id: 1, user_id: 1
# end

10.times do
  Album.create name: FFaker::Music.album, album_songs_attributes: [song_id: rand(1..10)]
end
