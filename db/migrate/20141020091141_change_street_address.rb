class ChangeStreetAddress < ActiveRecord::Migration
  def up
    change_table :listings do |t|
      t.change :street_address, :string
    end
  end
 
  def down
    change_table :products do |t|
      t.change :street_address, :integer
    end
  end
end
