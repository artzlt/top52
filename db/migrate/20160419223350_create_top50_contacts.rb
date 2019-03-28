class CreateTop50Contacts < ActiveRecord::Migration
  def change
    create_table :top50_contacts, :id => false do |t|
      t.integer :id
      t.string :name
      t.string :name_eng
      t.string :surname
      t.string :surname_eng
      t.string :patronymic
      t.string :patronymic_eng
      t.string :phone
      t.string :email
      t.text :extra_info
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
