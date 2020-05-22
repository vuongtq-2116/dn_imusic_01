20.times{
  Category.create(name: FFaker::Music.genre)
}

10.times{
  Album.create(name: FFaker::Music.album)
}
