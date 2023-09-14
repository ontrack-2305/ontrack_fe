class UsersController < ApplicationController
  def show
    @user = User.find_by(params[:google_id])
  end
end