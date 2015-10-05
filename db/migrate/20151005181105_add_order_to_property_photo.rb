class AddOrderToPropertyPhoto < ActiveRecord::Migration
  def change
    add_column :property_photos, :order_num, :integer
  end
end
