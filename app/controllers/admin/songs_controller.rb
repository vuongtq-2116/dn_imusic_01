class Admin::SongsController < Admin::BaseController
  def index
    @songs = Song.includes(:category).sort_by_created_at.paginate page: params[:page]
  end

  def show
    @song = Song.find_by id: params[:id]
    return if @song

    flash[:danger] = t "admin.songs.not_found_song"
    redirect_to admin_songs_path
  end
end
