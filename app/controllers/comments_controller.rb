class CommentsController < ApplicationController
  before_action :load_song, only: :create

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.new comment_params
    if @comment.save
      respond_to do |format|
        format.js
      end
    else
      flash[:danger] = t ".fail"
      redirect_to @song
    end
  end

  private

  def comment_params
    params.require(:comment).permit Comment::ATTR_PARAMS
  end

  def load_song
    @song = Song.find_by id: params[:song_id]
    return if @song

    flash[:danger] = t "admin.songs.not_found_song"
    redirect_to songs_path
  end
end
