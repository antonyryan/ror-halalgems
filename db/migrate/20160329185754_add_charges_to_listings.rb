class AddChargesToListings < ActiveRecord::Migration
  def change
    add_column :listings, :charges, :decimal
    add_column :listings, :maintenance, :decimal
  end
end
