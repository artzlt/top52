class CreateAlgoLaunchResults < ActiveRecord::Migration
  def change
    create_table :algo_launch_results, :id => false do |t|
      t.integer :id
      t.integer :launch_id
      t.float :result
      t.integer :measure_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
