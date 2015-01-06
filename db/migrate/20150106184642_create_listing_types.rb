class CreateListingTypes < ActiveRecord::Migration
  def change
    create_table :listing_types do |t|
      t.string :name
      t.string :string

      t.timestamps
    end
  end
end
