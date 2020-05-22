class Category < ApplicationRecord
  ATTR_PARAMS = :name

  self.per_page = Settings.categories.per_page

  has_many :songs, dependent: :destroy

  scope :sort_by_name, -> {order name: :asc}

  validates :name, presence: true, length: { in: Settings.categories.name_length_min..Settings.categories.name_length_max }, uniqueness: true
end
