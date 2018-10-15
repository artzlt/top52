class CreateSessionStats < ActiveRecord::Migration
  def change
    create_table :statistics_session_stats do |t|
      t.string :kind
      t.text :data
      t.timestamps
    end
  end
end
