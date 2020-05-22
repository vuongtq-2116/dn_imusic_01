module CommentsHelper
  def is_owner_cmt? comment
    comment.user_id == current_user.id
  end
end
