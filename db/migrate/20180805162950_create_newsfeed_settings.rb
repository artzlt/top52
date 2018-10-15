class CreateNewsfeedSettings < ActiveRecord::Migration
  def change
    create_table :newsfeed_settings do |t|
      t.integer :number_of_imported_news_shown, default: 20
      t.string :imported_news_source
      t.integer :number_of_local_news_shown, default: 2
      t.string :cron_schedule, default: 'hour'
      t.integer :cron_value, default: 1

      t.timestamps
    end
  end
end
