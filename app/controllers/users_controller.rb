class UsersController < ApplicationController
  before_action :validate_session
  
  def show
    @user = User.find_by(params[:google_id])
    # does this need to be defined at all if there's already a @_current_user?
  end
end