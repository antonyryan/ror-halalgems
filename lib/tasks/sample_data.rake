namespace :db do
  require 'faker'
  desc "Fill database with sample data"
  task populate_users: :environment do 
    User.delete_all 
    Faker::Config.locale = 'en-US'  
    5.times do |n|
      name  = Faker::Name.name
      email = Faker::Internet.email
      password  = "password"  
      address = Faker::Address.street_address
      phone = Faker::PhoneNumber.phone_number
      fax =  Faker::PhoneNumber.phone_number
      biography = Faker::Lorem.paragraph(10)
      license_no = Faker::Number.number(10)
      social_security_no = Faker::Number.number(10)
      commision_split = rand(0..100.0)
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end    
  end

  task populate_listings: :environment do
    Listing.delete_all

    users = User.all(limit: 5)
    5.times do |n|
      
      users.each do |user| 
        price = rand(1..10000.0)
        street_address = Faker::Address.street_address        
        description = Faker::Lorem.paragraphs.to_s
        size = rand(1..500)
        bed = Bed.offset(rand(Bed.count)).first
        status = Status.offset(rand(Status.count)).first
        full_baths_no = rand(1..5)
        half_baths_no = rand(1..5)
        user.listings.create!(price: price, street_address: street_address, description: description, size: size,
                              bed_id: bed.id, status_id: status.id, full_baths_no: full_baths_no, 
                              half_baths_no: half_baths_no) 
      end
    end    
  end 

end