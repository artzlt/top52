class CreateNewsfeedImports < ActiveRecord::Migration
  def change
    create_table :newsfeed_imports do |t|
      t.text :title
      t.string :initial_title
      t.text :link
      t.string :tags, array: true
      t.date :date_created
      t.boolean :is_ignoring, default: false
      t.boolean :is_last_imported, default: false

      t.timestamps
    end
  end
end
