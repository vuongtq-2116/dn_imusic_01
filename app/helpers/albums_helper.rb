module AlbumsHelper
  def load_all_song
    Song.pluck(:name, :id)
  end
end
