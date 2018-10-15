class Top50BaseController < ApplicationController
  before_action :require_admin_rights
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private

  def require_admin_rights
    unless User.superadmins.include? current_user
      flash[:error] = "Недостаточно полномочий для доступа к данной секции"
      redirect_to :back
    end
  end
end
