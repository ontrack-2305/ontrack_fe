class UsersController < ApplicationController
  before_action :validate_session
  
  def show
    @user = current_user
    # require 'pry'; binding.pry
    service = DatabaseService.new
    response = service.authenticate(@user)
    # does this need to be defined at all if there's already a @_current_user?
  end
end