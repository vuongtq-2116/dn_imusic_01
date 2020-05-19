class Song < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :users, through: :ratings, dependent: :destroy
  has_many :users, through: :favorite_songs, dependent: :destroy
  has_many :users, through: :lyric_requests, dependent: :destroy
  has_many :users, through: :comments, dependent: :destroy
end
