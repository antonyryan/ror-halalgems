require 'spec_helper'
include ActionView::Helpers::NumberHelper

describe "ListingPages" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in(user) }

  describe "show" do
	let(:listing) { FactoryGirl.create(:listing, user_id: user.id) }
	
	before { visit listing_path(listing) }

	it { should have_title(listing.street_address) }
	it { should have_content(listing.street_address) }	
  end

  describe "edit" do

  end
end
