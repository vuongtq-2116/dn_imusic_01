class Admin::AlbumsController < Admin::BaseController
  before_action :load_album, except: %i(index new create)

  def index
    @albums = Album.sort_by_name.paginate page: params[:page]
  end

  def new
    @album = Album.new
    @album_songs = @album.album_songs.build
  end

  def edit; end

  def show; end

  def create
    @album = Album.new album_params
    if check_params_duplicate
      flash.now[:danger] = t ".dup"
      render :new
      return
    end
    if @album.save
      flash[:success] = t ".success"
      redirect_to admin_albums_path
    else
      flash.now[:danger] = t ".fail"
      render :new
    end
  end

  private

  def album_params
    params.require(:album).permit Album::ATTR_PARAMS
  end

  def load_album
    @album = Album.find_by id: params[:id]
    return if @album

    flash[:danger] = t ".not_found_album"
    redirect_to admin_albums_path
  end

  def check_params_duplicate
    array_in = []
    params[:album][:album_songs_attributes].values.map{|value| array_in << value.values }
    unless array_in.uniq.length == array_in.length
      return true
    end
    false
  end
end
