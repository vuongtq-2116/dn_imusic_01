module FavoriteSongsHelper
  def load_fs song
    current_user.favorite_songs.find_by song_id: song.id
  end
end
