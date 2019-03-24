class NewsfeedEditLocalController < NewsfeedBaseController
  def index
    @local_news = NewsfeedLocal.all.order("date_created DESC")
    @local_news ||= []
  end
end