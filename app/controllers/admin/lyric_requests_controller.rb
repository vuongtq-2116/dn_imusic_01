class Admin::LyricRequestsController < Admin::BaseController
  before_action :load_song, only: %i(update get_approve)
  before_action :load_lyric, only: :update

  def index
    @lyric_requests = LyricRequest.is_unapprove.select("distinct on (song_id) *")
  end

  def update
    return if LyricRequest.statuses.include? lyric_params[:status].to_i
    if @lyric_request.update_attributes status: lyric_params[:status].to_i
      flash[:success] = "Updated lyric for this song"
      redirect_to admin_song_get_approve_path(@song)
    else
      flash[:danger] = "Cannot update lyric for this song"
    end
  end

  def get_approve
    @lyric_requests = LyricRequest.where("song_id = ?", params[:song_id])
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
    @lyric_request = LyricRequest.find_by id: params[:id]
    return if @lyric_request

    flash[:danger] = t "lyrics.not_found_lyric"
    redirect_to songs_path
  end
end
