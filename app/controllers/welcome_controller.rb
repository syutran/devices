class WelcomeController < ApplicationController

  def index
    respond_to do |format|
      if current_user && current_user.is_admin
        redirect_to manage_path
      elsif current_user && current_user.branches
        redirect_to devices_path
      end
      format.html
      format.js
    end
  end
end
