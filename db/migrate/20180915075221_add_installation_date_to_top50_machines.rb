class AddInstallationDateToTop50Machines < ActiveRecord::Migration
  def change
    add_column :top50_machines, :installation_date, :date
  end
end
