class Album < ApplicationRecord
  has_many :album_songs, dependent: :destroy
  has_many :songs, through: :album_songs

  scope :sort_by_name, -> {order name: :asc}
end
