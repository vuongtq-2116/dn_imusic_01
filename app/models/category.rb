class Category < ApplicationRecord
  has_many :songs, dependent: :destroy
end
