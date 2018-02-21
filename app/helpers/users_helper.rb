module UsersHelper

  # 本组的所有管理员
  def get_managers
    if current_user.is_admin
      User.where(:group => current_user.group).map { |m| ["#{m.name}(#{m.email})", m.id]}
    else
      [[current_user.name,current_user.id]]
    end
  end

  def user_grade_title(grade)
    title = "未设置"
    case grade
    when 0
      title = "未设置"
    when 1
      title = "普通管理员"
    when 7
      title = "SPY"
    when 9
      title = "高级管理员"
    end
    return title
  end
end
