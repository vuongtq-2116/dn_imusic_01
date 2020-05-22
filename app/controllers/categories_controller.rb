class CategoriesController < ApplicationController
  before_action :logged_in_user

  def index
    @categories = Category.sort_by_name.paginate page: params[:page]
  end

  def show; end
end
