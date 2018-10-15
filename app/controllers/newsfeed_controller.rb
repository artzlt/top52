class NewsfeedController < ApplicationController
	skip_before_filter :require_login#, only: []

	def index
		@settings = NewsfeedSettingsController.settings
    @settings.start_date = params.has_key?(:start_date) ? params[:start_date].to_date : nil
    @settings.end_date = params.has_key?(:end_date) ? params[:end_date].to_date : nil
		@settings.tag = params[:tag]
		prepare_local_news()
		
		if @settings.start_date != nil and @settings.end_date != nil
			@posts = NewsfeedImport.where("is_ignoring IS FALSE AND date_created <= (?) AND date_created >= (?)", @settings.end_date, @settings.start_date).order("date_created DESC")
		elsif @settings.start_date != nil
			@posts = NewsfeedImport.where("is_ignoring IS FALSE AND date_created >= (?)", @settings.start_date).order("date_created DESC")
		elsif @settings.end_date != nil
			@posts = NewsfeedImport.where("is_ignoring IS FALSE AND date_created <= (?)", @settings.end_date).order("date_created DESC")
		else
			@posts = NewsfeedImport.where("is_ignoring IS FALSE").order("date_created DESC")
		end

		if @settings.tag and @settings.tag.length > 0
			@posts = @posts.where("tags @> ARRAY['#{@settings.tag}']::varchar[]")
		end

		@posts = @posts.paginate(:page => params[:page], :per_page => @settings.number_of_imported_news_shown)
		@posts ||= []
	end

	def create
		newsfeed_settings = params[:newsfeed_settings]
		redirect_to newsfeed_index_path(:start_date => newsfeed_settings[:start_date].to_date, 
																		:end_date => newsfeed_settings[:end_date].to_date,
																		:tag => newsfeed_settings[:tag].blank? ? nil : newsfeed_settings[:tag])
	end

	def update
		newsfeed_settings = params[:newsfeed_settings]
		redirect_to newsfeed_index_path(:start_date => newsfeed_settings[:start_date].to_date, 
																		:end_date => newsfeed_settings[:end_date].to_date,
																		:tag => newsfeed_settings[:tag].blank? ? nil : newsfeed_settings[:tag])
	end
	
	private
	def prepare_local_news()
		relevant_news = NewsfeedLocal.where("start_date <= (?) AND end_date >= (?)", Date.today, Date.today)

		date_actual_news = relevant_news.where("header_weight IS NULL AND footer_weight IS NULL").order("date_created DESC").first(@settings.number_of_local_news_shown)
		header_pinned_news = relevant_news.where("header_weight IS NOT NULL").order("header_weight ASC").first(@settings.number_of_local_news_shown)
		footer_pinned_news = relevant_news.where("footer_weight IS NOT NULL").order("footer_weight DESC").first(@settings.number_of_local_news_shown)

		merged = header_pinned_news + date_actual_news + footer_pinned_news
		@local_news = merged[0...@settings.number_of_local_news_shown]
		@local_news ||= []
	end
end