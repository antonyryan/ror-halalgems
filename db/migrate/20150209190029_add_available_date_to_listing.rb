class AddAvailableDateToListing < ActiveRecord::Migration
  def change
    add_column :listings, :available_date, :date
    add_index :listings, :available_date
  end
end
