class CreateAlgowikiEntities < ActiveRecord::Migration
  def change
    create_table :algowiki_entities do |t|
      t.string :name
      t.string :name_eng
      t.integer :type_id
      t.string :wiki_link
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
