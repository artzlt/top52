class CreateAlgowikiRelations < ActiveRecord::Migration
  def change
    create_table :algowiki_relations do |t|
      t.integer :prim_id
      t.integer :sec_id
      t.integer :type_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
