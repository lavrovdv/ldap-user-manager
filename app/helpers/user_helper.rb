module UserHelper
  # Метод отображает на странице чекбоксы для всех приложений, для запрета доступа к приложению нужно указать приложение
  #
  def application_selector(user)
    html = ""
    User.application_list.each do |app|
      html += '<p>' + check_box_tag('[form][applications]'+app, app, user.is_a?(User) ? user.get_field('l').to_s.include?(app) : false)  + app + '</p>'
    end
    raw html
  end

  def default_application_selector
    html = ""
    Application.all.each do |app|
      html += '<p>' + check_box_tag('[form][applications]' + app.name, app.name, app.default)  + app.name + '</p>'
    end
    raw html
  end

end
