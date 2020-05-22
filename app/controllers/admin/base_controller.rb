class Admin::BaseController < ApplicationController
  before_action :logged_in_user
  before_action :restrict_user_by_role

  def restrict_user_by_role
    return if current_user.admin?

    flash[:danger] = t "layouts.header.not_admin"
    redirect_to root_path
  end
end
