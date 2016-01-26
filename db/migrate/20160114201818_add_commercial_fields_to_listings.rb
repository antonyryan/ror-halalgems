class AddCommercialFieldsToListings < ActiveRecord::Migration
  def change
    add_column :listings, :type_of_space_id, :integer
    add_column :listings, :dividable, :boolean, default: false
    add_column :listings, :taxes_included, :boolean, default: false
    add_column :listings, :taxes_amount, :decimal
  end
end
