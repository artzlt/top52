class NewsfeedEditLocalController < ApplicationController
  before_filter :require_login
  before_filter :authorize_admins!

  def index
    @local_news = NewsfeedLocal.all.order("date_created DESC")
    @local_news ||= []
  end

  private
  def authorize_admins!
    authorize! :access, :admin
  end
end