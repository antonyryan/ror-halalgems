class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :agent_id
      t.string :main_photo
      t.integer :street_address
      t.string :zip_code
      t.decimal :price
      t.integer :size
      t.text :description

      t.timestamps
    end
  end
end
