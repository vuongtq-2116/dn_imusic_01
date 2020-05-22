class SongsController < ApplicationController
  def index
    if params[:search]
      @songs = Song.search(params[:search]).paginate page: params[:page]
    else
      @songs = Song.includes(:category).sort_by_created_at.paginate page: params[:page]
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @song = Song.find_by id: params[:id]
    return if @song

    flash[:danger] = t "admin.songs.not_found_song"
    redirect_to songs_path
  end
end
