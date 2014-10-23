class AddFieldsToUsers < ActiveRecord::Migration
	def change
		add_column :users, :phone, :string
		add_column :users, :fax, :string
		add_column :users, :biography, :text
		add_column :users, :address, :string
		add_column :users, :license_no, :string
		add_column :users, :social_security_no, :string
		add_column :users, :commision_split, :float
	end
end
