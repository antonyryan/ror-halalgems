class AddParkingAndStorageToFeatures < ActiveRecord::Migration
  def change
    add_column :listings, :parking_available, :boolean, default: false
    add_column :listings, :storage_available, :boolean, default: false
  end
end
