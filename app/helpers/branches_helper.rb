module BranchesHelper
  def get_grade_branches
    if current_user.is_admin
      branches = Branch.where(group: current_user.group).order("branch_id").map { |m| [m.branch_id + "-" + m.branch, m.id] }
    else
      branches = current_user.branches.map { |m| [m.branch_id + "-" + m.branch,m.id]}
    end
  end

  def get_branch(branch)
    Branch.find(branch)
  end
end
