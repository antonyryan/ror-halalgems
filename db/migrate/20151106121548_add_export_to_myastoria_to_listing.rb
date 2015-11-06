class AddExportToMyastoriaToListing < ActiveRecord::Migration
  def change
    add_column :listings, :export_to_myastoria, :boolean, default: false
  end
end
