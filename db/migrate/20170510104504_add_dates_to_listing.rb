class AddDatesToListing < ActiveRecord::Migration
  def change
  	add_column :listings, :contract_date, :date
  	add_column :listings, :close_date, :date
  end
end
