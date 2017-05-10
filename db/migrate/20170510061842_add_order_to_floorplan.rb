class AddOrderToFloorplan < ActiveRecord::Migration
  def change
  	add_column :property_floorplans, :order_num, :integer
  end
end
