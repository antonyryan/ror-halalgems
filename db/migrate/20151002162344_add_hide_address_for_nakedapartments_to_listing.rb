class AddHideAddressForNakedapartmentsToListing < ActiveRecord::Migration
  def change
    add_column :listings, :hide_address_for_nakedapartments, :boolean, default: false
  end
end
