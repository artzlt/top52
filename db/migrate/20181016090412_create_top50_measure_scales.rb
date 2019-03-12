class CreateTop50MeasureScales < ActiveRecord::Migration
  def change
    create_table :top50_measure_scales do |t|
      t.string :name
      t.string :name_eng
      t.float :scale
      t.integer :measure_unit_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
