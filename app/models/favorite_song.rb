class FavoriteSong < ApplicationRecord
  ATTR_PARAMS = %i(user_id song_id)
  belongs_to :song
  belongs_to :user
end
