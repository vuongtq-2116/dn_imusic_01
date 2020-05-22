class FavoriteSongsController < ApplicationController
  before_action :logged_in_user
  before_action :load_song, :load_favorite_song, only: %i(create destroy)

  def index
    @favorite_songs = current_user.favorite_songs.includes(:song)
  end
  def create
    @favorite_song = current_user.favorite_songs.build fs_params
    unless @favorite_song.save
      flash.now[:danger] = t "admin.favorite_songs.create.fail"
    end
    respond_to :js
  end

  def destroy
    unless @favorite_song.destroy
      flash.now[:danger] = t "admin.favorite_songs.destroy.fail"
    end
    respond_to :js
  end

  private
  def fs_params
    params.require(:favorite_song).permit FavoriteSong::ATTR_PARAMS
  end

  def load_favorite_song
    @favorite_song = @song.favorite_songs.find_by id: params[:id]
    return if @favorite_song

    flash.now[:danger] = t "admin.favorite_songs.not_found_fs"
    respond_to :js
  end

  def load_song
    @song = Song.find_by id: params[:song_id]
    return if @song

    flash[:danger] = t "admin.songs.not_found_song"
    redirect_to admin_songs_path
  end
end
