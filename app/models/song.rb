class Song < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :users, through: :ratings, dependent: :destroy
  has_many :users, through: :favorite_songs, dependent: :destroy
  has_many :users, through: :lyric_requests, dependent: :destroy
  has_many :users, through: :comments, dependent: :destroy
  has_many :album_songs, dependent: :destroy
  has_many :albums, through: :album_songs
  scope :active, ->{where deleted_at: nil}
  scope :sort_by_created_at, -> {order created_at: :asc}

  def blank_stars
    5 - star_avg.to_i
  end
end
