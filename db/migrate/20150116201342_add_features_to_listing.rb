class AddFeaturesToListing < ActiveRecord::Migration
  def change
    add_column :listings, :dishwasher, :boolean, default: false
    add_column :listings, :backyard, :boolean, default: false
    add_column :listings, :balcony, :boolean, default: false
    add_column :listings, :elevator, :boolean, default: false
    add_column :listings, :laundry_in_building, :boolean, default: false
    add_column :listings, :laundry_in_unit, :boolean, default: false
    add_column :listings, :live_in_super, :boolean, default: false
    add_column :listings, :absentee_landlord, :boolean, default: false
  end
end
