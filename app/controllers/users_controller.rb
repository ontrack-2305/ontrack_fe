class UsersController < ApplicationController
  before_action :validate_session
  
  def show
    user = User.find_by(google_id: params[:google_id])
    service = DatabaseService.new
    require 'pry'; binding.pry
    response = service.authenticate(user)
    # does this need to be defined at all if there's already a @_current_user?
  end

  def authenticate
    user = User.find_by(google_id: params[:google_id])
    service = DatabaseService.new
    response = service.authenticate(user)
  end
end