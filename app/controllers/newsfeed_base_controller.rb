class NewsfeedBaseController < ApplicationController
  before_action :require_moder_rights
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private

  def require_moder_rights
    unless current_user.may_manage_news?
      flash[:error] = "Недостаточно полномочий для доступа к данной секции"
      redirect_to :back
    end
  end
end
