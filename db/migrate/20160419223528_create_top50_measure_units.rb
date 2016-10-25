class CreateTop50MeasureUnits < ActiveRecord::Migration
  def change
    create_table :top50_measure_units do |t|
      t.string :name
      t.string :name_eng
      t.integer :asc_order
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
