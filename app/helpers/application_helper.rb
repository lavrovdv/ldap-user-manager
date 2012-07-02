module ApplicationHelper

  def check_connection?
    begin
      User.find(:first)
    rescue
      false
    end
  end
end
