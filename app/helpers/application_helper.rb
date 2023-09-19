module ApplicationHelper
  def dark_mode_enabled?
    if cookies["theme"] == "dark"
      true
    else
      false
    end
  end
end
