class AddLicenseTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :license_type, :string
  end
end
