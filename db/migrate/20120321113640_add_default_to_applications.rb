class AddDefaultToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :default, :boolean, :default => false
  end
end
