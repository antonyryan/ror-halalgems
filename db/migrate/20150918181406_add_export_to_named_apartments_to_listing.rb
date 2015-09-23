class AddExportToNamedApartmentsToListing < ActiveRecord::Migration
  def change
    add_column :listings, :export_to_nakedapartments, :boolean, default: false
  end
end
