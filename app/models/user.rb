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
  before_create :create_activation_digest
  validates :email, presence: true,
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  has_secure_password

  scope :active, ->{where deleted_at: nil}

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
