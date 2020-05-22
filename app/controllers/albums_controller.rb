class AlbumsController < ApplicationController
  before_action :logged_in_user

  def index
    @albums = Album.sort_by_name.paginate page: params[:page]
  end

  def show; end
end
