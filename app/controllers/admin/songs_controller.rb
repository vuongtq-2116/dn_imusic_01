class Admin::SongsController < Admin::BaseController
  def index
    @songs = Song.search(params[:search]).sort_by_created_at.paginate page: params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @song = Song.new
  end

  def show
    @song = Song.find_by id: params[:id]
    return if @song

    flash[:danger] = t "admin.songs.not_found_song"
    redirect_to admin_songs_path
  end

  def create
    @song = current_user.songs.new song_params
    if @song.save
      flash[:success] = t ".success"
      redirect_to admin_songs_path
    else
      flash.now[:danger] = t ".fail"
      render :new
    end
  end

  private

  def song_params
    params.require(:song).permit Song::ATTR_PARAMS
  end
end
