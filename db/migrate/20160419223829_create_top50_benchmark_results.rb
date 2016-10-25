class CreateTop50BenchmarkResults < ActiveRecord::Migration
  def change
    create_table :top50_benchmark_results do |t|
      t.integer :benchmark_id
      t.integer :machine_id
      t.float :result
      t.date :start_date
      t.date :end_date
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
