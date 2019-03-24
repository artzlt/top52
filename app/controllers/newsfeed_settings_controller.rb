class NewsfeedSettingsController < NewsfeedBaseController
  def show
    default_vals()
  end

  def index
    default_vals()
  end

  def create

  end

  def update
    puts params
    pars = newsfeed_settings_params()
    @settings = NewsfeedSettings.first
    @settings.imported_news_source = pars[:imported_news_source]
    @settings.cron_schedule = pars[:cron_schedule]
    @settings.cron_value = pars[:cron_value]
    @settings.save()
    redirect_to('/newsfeed_settings')
  end

  def self.settings
    settings = NewsfeedSettings.first
    if settings == nil
      return NewsfeedSettingsController.default_settings
    end
    return settings
  end

  def self.default_settings
    settings = NewsfeedSettings.new
    settings.cron_schedule = "hour"
    settings.cron_value = 1
    settings.imported_news_source = "http://parallel.ru"
    return settings
  end

  private
  def default_vals
    @local_news = NewsfeedLocal.all.order("date_created DESC")
    @local_news ||= []
    @settings = NewsfeedSettings.first
    if @settings == nil
      @settings = NewsfeedSettingsController.default_settings
      @settings.save()
    end
  end

  def newsfeed_settings_params
    return params.require(:newsfeed_settings).permit(:number_of_imported_news_shown, :imported_news_source, :number_of_local_news_shown, :cron_schedule, :cron_value)
  end
end