class AddIsForExportToListing < ActiveRecord::Migration
  def change
    add_column :listings, :is_for_export, :boolean, default: false
  end
end
