class LyricRequest < ApplicationRecord
  belongs_to :song
  belongs_to :user
  enum status: {unapprove: 0, approved: 1, approved_show: 2}
end
