class Admin::SongsController < Admin::BaseController
  before_action :load_song, except: %i(index new create)

  def index
    @songs = Song.search(params[:search]).active.sort_by_created_at.paginate page: params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @song = Song.new
  end

  def edit; end

  def show; end

  def create
    @song = current_user.songs.new song_params
    if @song.save
      flash[:success] = t ".success"
      redirect_to admin_song_path @song
    else
      flash.now[:danger] = t ".fail"
      render :new
    end
  end

  def update
    if @song.update song_params
      flash[:success] = t ".success"
      redirect_to admin_song_path @song
    else
      flash.now[:danger] = t ".fail"
      render :edit
    end
  end

  def destroy
    if @song.update_attribute :deleted_at, Time.now
      flash[:success] = t ".deleted"
    else
      flash[:danger] = t ".cannot_deleted"
    end
    redirect_to admin_songs_path
  end

  private

  def song_params
    params.require(:song).permit Song::ATTR_PARAMS
  end

  def load_song
    @song = Song.find_by id: params[:id]
    return if @song

    flash[:danger] = t "admin.songs.not_found_song"
    redirect_to admin_songs_path
  end
end
