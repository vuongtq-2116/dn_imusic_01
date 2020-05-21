class Album < ApplicationRecord
  ATTR_PARAMS = :name
  has_many :songs, through: :album_songs, dependent: :destroy

  scope :sort_by_name, -> {order name: :asc}
end
