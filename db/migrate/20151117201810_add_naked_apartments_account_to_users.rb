class AddNakedApartmentsAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :naked_apartments_account, :boolean, default: false
  end
end
