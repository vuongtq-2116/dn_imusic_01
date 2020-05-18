class Category < ApplicationRecord
  ATTR_PARAMS = :name
  has_many :songs, dependent: :destroy

  scope :sort_by_name, -> {order name: :asc}
end
