class AddOrderToVideoplan < ActiveRecord::Migration
  def change
  	add_column :property_videos, :order_num, :integer
  end
end
