module SongsHelper
  def load_all_cate
    Category.pluck(:name, :id)
  end
end
