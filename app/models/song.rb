class Song < ApplicationRecord
  ATTR_PARAMS = %i(name description category_id user_id artist star_avg song_file)
  belongs_to :user
  belongs_to :category
  has_many :users, through: :ratings, dependent: :destroy
  has_many :users, through: :favorite_songs, dependent: :destroy
  has_many :users, through: :lyric_requests, dependent: :destroy
  has_many :users, through: :comments, dependent: :destroy
  has_many :album_songs, dependent: :destroy
  has_many :albums, through: :album_songs
  has_one_attached :song_file

  scope :active, ->{where deleted_at: nil}
  scope :sort_by_created_at, ->{order created_at: :desc}
  scope :search, ->(search){left_outer_joins(:category, album_songs: :album)
    .where("songs.name ilike ? or songs.artist ilike ? or categories.name ilike ? or albums.name ilike ?",
    "%#{search}%",
    "%#{search}%",
    "%#{search}%",
    "%#{search}%") if search.present? }

  def blank_stars
    5 - star_avg.to_i
  end
end
