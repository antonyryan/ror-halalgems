class AddZumperFieldsToListings < ActiveRecord::Migration
  def change
    add_column :listings, :exported_to_zumper, :boolean, default: false
    add_column :listings, :export_to_zumper, :boolean, default: false
  end
end
