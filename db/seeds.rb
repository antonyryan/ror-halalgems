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

Status.create([ {name: 'New', is_for_rentals: false}, {name: 'Accepted offer', is_for_rentals: false},
                {name: 'Under contract', is_for_rentals: false}, {name: 'Price change', is_for_rentals: false},
                {name: 'Closed', is_for_rentals: false}, {name: 'Temporary off market', is_for_rentals: false},
                {name: 'Withdrawn', is_for_rentals: false},

                {name: 'Closed', is_for_rentals: true},
                {name: 'New', is_for_rentals: true}, {name: 'Price change', is_for_rentals: true},
                {name: 'Deposit/Pending Application', is_for_rentals: true}, {name: 'Rented', is_for_rentals: true},
                {name: 'Temporary off market', is_for_rentals: true}, {name: 'Lost', is_for_rentals: true}
			        ])
#Astoria, Sunnyside, Jackson Heights, Woodside, Long Island City, Forest Hills, Kew Gardens, Rego Park, Corona
Neighborhood.create([{name: 'Astoria'}, {name: 'Sunnyside'}, {name: 'Jackson Heights'},  {name: 'Woodside'},
			 {name: 'Long Island City'}, {name: 'Forest Hills'}, {name: 'Kew Gardens'}, 
			 {name: 'Rego Park'}, {name: 'Corona'}, {name: 'Elmhurst'}, {name: 'E. Elmhurst'}, {name: 'Flushing'},
       {name: 'Whitestone'}, {name: 'Bayside'}, {name: 'Manhattan'}])

PropertyType.create([{name: 'Private House'}, {name: 'Multi-family'}, {name: 'Coop'},  {name: 'Condo'},
                     {name: 'Land'},  {name: 'Garage'},  {name: 'Parking Space'},  {name: 'Single Family'}])

ListingType.create([{name: 'Rental'}, {name: 'Sale'}])


#Status.create([ {name: 'New', is_for_rentals: false}, {name: 'Accepted offer', is_for_rentals: false}, {name: 'Under contract', is_for_rentals: false},                {name: 'Price change', is_for_rentals: false}, {name: 'Closed', is_for_rentals: false},                {name: 'Temporary off market', is_for_rentals: false}, {name: 'Withdrawn', is_for_rentals: false}, {name: 'Closed', is_for_rentals: false},                {name: 'New', is_for_rentals: true}, {name: 'Price change', is_for_rentals: true}, {name: 'Deposit/Pending Application', is_for_rentals: true},                {name: 'Temporary off market', is_for_rentals: true}, {name: 'Rented', is_for_rentals: true}, {name: 'Lost', is_for_rentals: true}              ])