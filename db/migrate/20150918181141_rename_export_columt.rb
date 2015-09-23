class RenameExportColumt < ActiveRecord::Migration
  def change
    rename_column :listings, :is_for_export, :export_to_streeteasy
  end
end
