class AddPetsToListing < ActiveRecord::Migration
  def change
    add_column :listings, :no_pets, :boolean, default: false;
    add_column :listings, :cats, :boolean, default: false;
    add_column :listings, :dogs, :boolean, default: false;
    add_column :listings, :approved_pets_only, :boolean, default: false;
  end
end
