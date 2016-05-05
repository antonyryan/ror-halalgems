class AddActionAgentToListings < ActiveRecord::Migration
  def change
    add_column :listings, :action_user_id, :integer
  end
end
