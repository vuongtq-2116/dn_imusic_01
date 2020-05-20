class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.active.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def show; end

  def edit; end

  def create
    @user = User.new user_params
    if @user.save
      send_mail_activate @user
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.update_attribute :deleted_at, Time.now
      flash[:success] = t ".deleted"
    else
      flash[:danger] = t ".cannot_deleted"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit User::ATTR_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".not_found_user"
    redirect_to root_path
  end

  def send_mail_activate user
    UserMailer.account_activation(user).deliver_now
    flash[:info] = t ".check_mail_active"
    redirect_to root_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end
end
