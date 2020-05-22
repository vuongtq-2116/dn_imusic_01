class User < ApplicationRecord
  ATTR_PARAMS = %i(name email password password_confirmation role deletion).freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  attr_accessor :activation_token
  has_many :songs, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :favorite_songs, dependent: :destroy
  has_many :lyric_requests, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum role: {user: 0, admin:1}
  validates :email, presence: true,
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  scope :active, ->{where deleted_at: nil}
end
