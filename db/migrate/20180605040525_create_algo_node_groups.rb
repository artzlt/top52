class CreateAlgoNodeGroups < ActiveRecord::Migration
  def change
    create_table :algo_node_groups, :id => false do |t|
      t.integer :id
      t.string :name
      t.string :name_eng
      t.integer :machine_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
