class AddUtilitiesToListing < ActiveRecord::Migration
  def change
    add_column :listings, :heat_and_hot_water, :boolean, default: false
    add_column :listings, :gas, :boolean, default: false
    add_column :listings, :all_utilities, :boolean, default: false
    add_column :listings, :none, :boolean, default: false
  end
end
