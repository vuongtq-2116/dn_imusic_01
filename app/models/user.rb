class User < ApplicationRecord
  has_many :songs, dependent: :destroy
  has_many :songs, through: :ratings, dependent: :destroy
  has_many :songs, through: :favorite_songs, dependent: :destroy
  has_many :songs, through: :lyric_requests, dependent: :destroy
  has_many :songs, through: :comments, dependent: :destroy

  enum role: {user: 0, admin: 1}
end
