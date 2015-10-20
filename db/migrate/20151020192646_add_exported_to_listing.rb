class AddExportedToListing < ActiveRecord::Migration
  def change
    add_column :listings, :exported_to_streeteasy, :boolean, default: false
    add_column :listings, :exported_to_myastoria, :boolean, default: false
  end
end
