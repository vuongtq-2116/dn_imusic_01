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

  def show
    @songs = @album.album_songs
  end

  def create
    @album = Album.new album_params
    case check_params_duplicate params
    when 1
      flash[:danger] = t "admin.albums.create.dup"
      render :new
      return
    when 2
      flash[:danger] = t "admin.albums.update.fail_cannot_remove"
      render :new
      return
    else
    end

    if @album.save
      flash[:success] = t ".success"
      redirect_to admin_albums_path
    else
      flash.now[:danger] = t ".fail"
      render :new
    end
  end

  def update
    Album.transaction do
      case check_params_duplicate params
      when 1
        flash[:danger] = t "admin.albums.create.dup"
        redirect_to edit_admin_album_path @album
        raise ActiveRecord::Rollback
      when 2
        flash[:danger] = t "admin.albums.update.fail_cannot_remove"
        redirect_to edit_admin_album_path @album
        raise ActiveRecord::Rollback
      else
      end

      if @album.update album_params
        flash[:success] = t ".success"
        redirect_to admin_albums_path
      else
        flash.now[:danger] = t ".fail"
        render :edit
        raise ActiveRecord::Rollback
      end
    end
  end

  def destroy
    if @album.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to admin_albums_path
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

  # 0: not duplicate; 1: duplicate; 2: cannot delete all song
  def check_params_duplicate params
    return 0 if params.nil? or params[:album][:album_songs_attributes].blank?
    array_in = []
    params[:album][:album_songs_attributes].values.map do |v|
       if v.size == 1
        array_in << v.values[0]
       else
        array_in << v.values[0] if v.values[1] == "0"
       end
    end
    return 2 if array_in.blank?
    unless array_in.uniq.length == array_in.length
      return 1
    end
    0
  end
end
