class LyricRequestsController < ApplicationController
  before_action :load_song, only: %i(create update)
  before_action :load_lyric, only: %i(show update)

  def show; end

  def create
    @lyric_request = current_user.lyric_requests.build lyric_params
    if @lyric_request.save
      flash.now[:success] = t "lyrics.create.success"
    else
      flash.now[:danger] = t "lyrics.create.fail"
    end
    respond_to :js
  end

  def update
    if @lyric_request.update lyric_params
      @lyric_request.unapprove!
      flash.now[:success] = t "lyrics.update.success"
    else
      flash.now[:danger] = t "lyrics.update.fail"
    end
    respond_to :js
  end

  private

  def lyric_params
    params.require(:lyric_request).permit LyricRequest::ATTR_PARAMS
  end

  def load_song
    @song = Song.find_by id: params[:song_id]
    return if @song

    flash[:danger] = t "admin.songs.not_found_song"
    redirect_to songs_path
  end

  def load_lyric
    @lyric_request = current_user.lyric_requests.find_by id: params[:id]
    return if @lyric_request

    flash[:danger] = t "lyrics.not_found_lyric"
    redirect_to songs_path
  end
end
