class AlbumsController < ApplicationController
  before_action :logged_in_user
  before_action :check_admin, except: :index
  before_action :load_album, except: %i(index new create)

  def index
    @albums = Album.sort_by_name.paginate page: params[:page]
  end

  def new
    @album = Album.new
  end

  def edit; end

  def show; end

  def create
    @album = Album.new album_params
    if @album.save
      flash[:success] = t ".success"
      redirect_to albums_path
    else
      flash.now[:danger] = t ".fail"
      render :new
    end
  end

  def update
    if @album.update album_params
      flash[:success] = t ".success"
      redirect_to albums_path
    else
      flash.now[:danger] = t ".fail"
      render :edit
    end
  end

  def destroy
    if @album.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to albums_path
  end

  private

  def album_params
    params.require(:album).permit Album::ATTR_PARAMS
  end

  def load_Album
    @album = Album.find_by id: params[:id]
    return if @album

    flash[:danger] = t ".not_found_album"
    redirect_to albums_path
  end
end
