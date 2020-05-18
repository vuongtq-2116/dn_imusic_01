class Album < ApplicationRecord
  has_many :songs, through: :album_songs, dependent: :destroy
end
