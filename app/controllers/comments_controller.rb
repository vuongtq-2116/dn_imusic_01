class CommentsController < ApplicationController
  include CommentsHelper

  before_action :load_song, except: %i(new index show)
  before_action :load_comment, only: %i(edit update destroy)

  def new
    @comment = Comment.new
  end

  def edit
    respond_to :js
  end

  def create
    @comment = current_user.comments.build comment_params
    if @comment.save
      flash.now[:success] = t "admin.comments.create.success"
    else
      flash.now[:danger] = t "admin.comments.create.fail"
    end
    respond_to :js
  end

  def update
    if @comment.update comment_params
      flash.now[:success] = t "admin.comments.update.success"
    else
      flash.now[:danger] = t "admin.comments.update.fail"
    end
    respond_to :js
  end

  def destroy
    return redirect_to @song unless is_owner_cmt? @comment

    if @comment.destroy
      flash.now[:success] = t "admin.comments.destroy.success"
    else
      flash.now[:danger] = t "admin.comments.destroy.fail"
    end
    respond_to :js
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

  def load_comment
    @comment = @song.comments.find_by id: params[:id]
    return if @comment

    flash[:danger] = t "admin.comments.not_found_cmt"
    redirect_to song_path @song
  end
end
