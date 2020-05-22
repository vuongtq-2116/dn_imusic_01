module RatingsHelper
  def rating_ballot
    if @rating = current_user.ratings.find_by(id: params[:id])
      @rating
    else
      current_user.ratings.build
    end
  end
end
