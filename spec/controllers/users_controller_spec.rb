require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'get #index' do
    describe 'filter' do
      describe 'ids' do
        let(:listing) { FactoryGirl.create :listing }
        it 'assigns right listings if ids parameter is empty' do
          sign_in listing.user, {:no_capybara => true}
          get :show, id: listing.user_id, ids: ['']
          expect(assigns(:listingss).to_a).to eq [listing]
        end
      end
    end
  end
end
