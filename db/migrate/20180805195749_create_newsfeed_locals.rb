class CreateNewsfeedLocals < ActiveRecord::Migration
  def change
    create_table :newsfeed_locals do |t|
      t.string :title
      t.text :announce
      t.text :body
      t.text :link
      t.date :date_created
      t.date :start_date
      t.date :end_date
      t.integer :header_weight
      t.integer :footer_weight

      t.timestamps
    end
  end
end
