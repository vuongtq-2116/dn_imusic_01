class Album < ApplicationRecord
  ATTR_PARAMS = [:name, album_songs_attributes: [:id, :album_id, :song_id, :_destroy]]
  has_many :album_songs, dependent: :destroy
  has_many :songs, through: :album_songs

  scope :sort_by_name, -> {order name: :asc}
  accepts_nested_attributes_for :album_songs, allow_destroy: true

  validates :name, presence: true,
                  length: { maximum: Settings.albums.name_length_max }

  before_save :upcase_name

  def upcase_name
    name.upcase!
  end
end
