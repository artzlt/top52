class NewsfeedEditImportController < NewsfeedBaseController

  def index
    @settings = NewsfeedSettingsController.settings
    @settings.start_date = params.has_key?(:start_date) ? params[:start_date].to_date : nil
    @settings.end_date = params.has_key?(:end_date) ? params[:end_date].to_date : nil
		@settings.tag = params[:tag]

    if @settings.start_date != nil and @settings.end_date != nil
			@import_news = NewsfeedImport.where("date_created <= (?) AND date_created >= (?)", @settings.end_date, @settings.start_date).order("date_created DESC")
		elsif @settings.start_date != nil
			@import_news = NewsfeedImport.where("date_created >= (?)", @settings.start_date).order("date_created DESC")
		elsif @settings.end_date != nil
			@import_news = NewsfeedImport.where("date_created <= (?)", @settings.end_date).order("date_created DESC")
		else
			@import_news = NewsfeedImport.all.order("date_created DESC")
    end
    
		if @settings.tag and @settings.tag.length > 0
			@import_news = @import_news.where("tags @> ARRAY['#{@settings.tag}']::varchar[]")
		end

    @import_news = @import_news.paginate(:page => params[:page], :per_page => @settings.number_of_imported_news_shown)
    @import_news ||= []
  end

  def create
		newsfeed_settings = params[:newsfeed_settings]
		redirect_to newsfeed_edit_import_index_path(:start_date => newsfeed_settings[:start_date].to_date, 
																		:end_date => newsfeed_settings[:end_date].to_date,
																		:tag => newsfeed_settings[:tag].blank? ? nil : newsfeed_settings[:tag])
	end

  def update
		newsfeed_settings = params[:newsfeed_settings]
		redirect_to newsfeed_edit_import_index_path(:start_date => newsfeed_settings[:start_date].to_date, 
																		:end_date => newsfeed_settings[:end_date].to_date,
																		:tag => newsfeed_settings[:tag].blank? ? nil : newsfeed_settings[:tag])
	end
end