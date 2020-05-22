class UsersController < ApplicationController
  before_action :logged_in_user, :load_user, :correct_user, only: :show

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      send_mail_activate @user
    else
      render :new
    end
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
