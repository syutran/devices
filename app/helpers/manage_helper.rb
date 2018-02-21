module ManageHelper
  def get_manage_branches
    branches =  [["未设置部门",0]]
    if current_user.is_admin
      branches = Branch.find(current_user.branch).branches.map { |m| [m.branch, m.id]}
    else
      branches = current_user.branches.map {|m| [m.branch, m.id]}
    end
    return branches
  end
end
