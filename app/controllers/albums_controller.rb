class AlbumsController < ApplicationController
  before_action :logged_in_user

  def index
    @albums = Album.sort_by_name.paginate page: params[:page]
  end

  def show
    @album = Album.find_by id: params[:id]
    if @album
      @songs = @album.album_songs
    else
      flash[:danger] = t "admin.albums.not_found_album"
      redirect_to albums_path
    end
  end
end
