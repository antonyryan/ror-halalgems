class AddFieldsSalesListings < ActiveRecord::Migration
  def change
    add_column :listings, :start_date, :date
    add_column :listings, :expiration_date, :date
    add_column :listings, :commission, :decimal
    add_column :listings, :mls_no, :string
    add_column :listings, :lot_size, :integer
    add_column :listings, :building_size, :integer
    add_column :listings, :interior_square_feet, :integer
    add_column :listings, :tax_abatement, :boolean, default: false
    add_column :listings, :tax_abatement_end_date, :date
  end
end
