class AddExportedToNakedapartmentsToListing < ActiveRecord::Migration
  def change
    add_column :listings, :exported_to_nakedapartments, :boolean, default: false
  end
end
