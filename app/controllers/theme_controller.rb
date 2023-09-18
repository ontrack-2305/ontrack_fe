class ThemeController < ApplicationController
  def update
    cookies[:theme] = params[:theme]
    redirect_to request.referer || root_path
  end
end