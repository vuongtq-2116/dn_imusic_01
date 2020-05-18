class User < ApplicationRecord
  ATTR_PARAMS = %i(name email password password_confirmation role deletion).freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  has_many :songs, dependent: :destroy
  has_many :songs, through: :ratings, dependent: :destroy
  has_many :songs, through: :favorite_songs, dependent: :destroy
  has_many :songs, through: :lyric_requests, dependent: :destroy
  has_many :songs, through: :comments, dependent: :destroy

  enum role: {user: 0, admin:1}

  validates :email, presence: true,
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  has_secure_password

  scope :active, ->{where deleted_at: nil}
end
