class Rating < ApplicationRecord
  ATTR_PARAMS = %i(user_id song_id star)
  belongs_to :song
  belongs_to :user
end
