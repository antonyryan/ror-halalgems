# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: 'admin', email: 'admin@example.com', password: 're_adm1n', password_confirmation: 're_adm1n', 
	admin: true)

Bed.create([{name: 'Studio'}, {name: 'Junior 1'}, {name: '1 Bedroom'},  {name: '1 Bedroom plus den'},
			 {name: 'Junior 4'}, {name: '2 Bedroom'}, {name: '2 Bedroom plus den'}, {name: '3 Bedroom'},
			 {name: '4 Bedroom'}, {name: 'Entire House'}])

Status.create([{name: 'Active'}, {name: 'Under Renovation'}, {name: 'Pending Approval'},  {name: 'Lost'},
			 {name: 'Rented'}])