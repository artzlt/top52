class CreateTop50Benchmarks < ActiveRecord::Migration
  def change
    create_table :top50_benchmarks do |t|
      t.string :name
      t.string :name_eng
      t.integer :measure_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
