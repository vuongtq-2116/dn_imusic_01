class Admin::UsersController < Admin::BaseController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.active.paginate page: params[:page]
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.update.update_success"
      redirect_to admin_user_path @user
    else
      render :edit
    end
  end

  def destroy
    User.transaction do
      if @user.update_attribute :deleted_at, Time.now
        @user.songs.update_all deleted_at: Time.now
        flash[:success] = t "users.destroy.deleted"
      else
        flash[:danger] = t "users.destroy.cannot_deleted"
        raise ActiveRecord::Rollback
      end
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit User::ATTR_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.show.not_found_user"
    redirect_to root_path
  end
end
