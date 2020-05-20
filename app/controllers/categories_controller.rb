class CategoriesController < ApplicationController
  before_action :logged_in_user, except: :index
  before_action :check_admin, except: %i(index new show)
  before_action :load_category, except: %i(index new)

  def index
    @categories = Category.sort_by_name.paginate page: params[:page]
  end

  def new
    @category = Category.new
  end

  def edit; end

  def show; end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t ".success"
      redirect_to @category
    else
      flash.now[:danger] = t ".fail"
      render :new
    end
  end

  def update
    if @category.update category_params
      flash[:success] = t ".success"
      redirect_to @categories
    else
      flash.now[:danger] = t ".fail"
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to @categories
  end

  private

  def category_params
    params.require(:category).permit Category::ATTR_PARAMS
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category

    flash[:danger] = t ".not_found_cat"
    redirect_to root_path
  end
end
