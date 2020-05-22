class Comment < ApplicationRecord
  ATTR_PARAMS = %i(user_id song_id content)
  belongs_to :song
  belongs_to :user

  scope :sort_by_create_at, -> {order created_at: :desc }
end
