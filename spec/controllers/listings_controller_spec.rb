require 'rails_helper'

describe ListingsController, type: :controller do
  describe "POST 'create'" do
    let(:listing_params) do
      FactoryGirl.attributes_for :listing, user_id: FactoryGirl.create(:user).id,
                                 listing_type_id: ListingType.create(name: 'Rental').id,
                                 property_type_id: PropertyType.create(name: 'Private House').id,
                                 neighborhood_id: Neighborhood.create(name: 'Astoria').id


    end
    before do
      ActionMailer::Base.delivery_method = :test
      Status.create([{name: 'New', is_for_rentals: false}, {name: 'Accepted offer', is_for_rentals: false},
                     {name: 'Under contract', is_for_rentals: false}, {name: 'Price change', is_for_rentals: false},
                     {name: 'Closed', is_for_rentals: false}, {name: 'Temporary off market', is_for_rentals: false},
                     {name: 'Withdrawn', is_for_rentals: false},

                     {name: 'Closed', is_for_rentals: true},
                     {name: 'New', is_for_rentals: true}, {name: 'Price change', is_for_rentals: true},
                     {name: 'Deposit/Pending Application', is_for_rentals: true}, {name: 'Rented', is_for_rentals: true},
                     {name: 'Temporary off market', is_for_rentals: true}, {name: 'Lost', is_for_rentals: true}
                    ])
    end
    describe 'as regular user' do
      let(:user) { FactoryGirl.create :user }
      it 'does not saves the agent' do
        sign_in user, {:no_capybara => true}
        post :create, listing: listing_params
        expect(Listing.last.user_id).to eq user.id
      end
    end
    describe 'as admin user' do
      let(:user) { FactoryGirl.create :user, admin: true }
      it 'saves the agent' do
        sign_in user, {:no_capybara => true}
        post :create, listing: listing_params
        expect(Listing.last.user_id).to eq listing_params[:user_id]
      end
    end

    describe 'emails' do
      let(:user) { FactoryGirl.create :user }
      it 'sends an email' do
        sign_in user, {:no_capybara => true}
        expect { post :create, listing: listing_params }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end
end
