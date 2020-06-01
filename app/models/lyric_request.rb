class LyricRequest < ApplicationRecord
  ATTR_PARAMS = %i(lyric_detail status user_id song_id)
  belongs_to :song
  belongs_to :user
  enum status: {unapprove: 0, approved: 1, approved_show: 2}

  scope :is_unapprove, ->{where("status = ?", 0)}
  scope :is_show, ->(song_id) {where("status = ? and song_id = ?", 2, song_id)}
end
