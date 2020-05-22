class RatingsController < ApplicationController
  before_action :load_song, only: %i(create update)
  before_action :load_rating, only: :update

  def create
    @rating = current_user.ratings.build rating_params
    if @rating.save
      average_rating @song
    else
      flash.now[:danger] = t "ratings.fail"
    end
    respond_to :js
  end

  def update
    if @rating.update rating_params
      average_rating @song
    else
      flash.now[:danger] = t "ratings.fail"
    end
    respond_to :js
  end

  private

  def rating_params
    params.require(:rating).permit Rating::ATTR_PARAMS
  end

  def average_rating song
    song.update_attributes star_avg: (song.ratings.sum(:star) / song.ratings.size)
  end

  def load_song
    @song = Song.find_by id: params[:song_id]
    return if @song

    flash[:danger] = t "admin.songs.not_found_song"
    redirect_to songs_path
  end

  def load_rating
    @rating = current_user.ratings.find_by id: params[:id]
    return if @rating

    flash[:danger] = t "ratings.not_found_rate"
    redirect_to songs_path
  end
end
