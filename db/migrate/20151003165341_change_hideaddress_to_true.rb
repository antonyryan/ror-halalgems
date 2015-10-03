class ChangeHideaddressToTrue < ActiveRecord::Migration
  def change
    change_column :listings, :hide_address_for_nakedapartments, :boolean, default: true
  end
end
