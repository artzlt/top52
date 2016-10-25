class CreateTop50RelationTypes < ActiveRecord::Migration
  def change
    create_table :top50_relation_types do |t|
      t.string :name
      t.string :name_eng
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
