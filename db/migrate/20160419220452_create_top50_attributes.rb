class CreateTop50Attributes < ActiveRecord::Migration
  def change
    create_table :top50_attributes do |t|
      t.string :name
      t.string :name_eng
      t.integer :attr_type
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
