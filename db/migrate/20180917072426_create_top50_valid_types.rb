class CreateTop50ValidTypes < ActiveRecord::Migration
  def change
    create_table :top50_valid_types do |t|
      t.string :name
      t.string :name_eng
      t.string :comment

      t.timestamps
    end
  end
end
