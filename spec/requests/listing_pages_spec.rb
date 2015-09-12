require 'spec_helper'
include ActionView::Helpers::NumberHelper

describe 'ListingPages' do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  before do
    ListingType.create([{name: 'Sale'}, {name: 'Rental'}])
    sign_in(user)

  end

  describe 'show' do
    let(:listing) { FactoryGirl.create(:listing, user_id: user.id) }

    before { visit listing_path(listing) }

    it { should have_title(listing.street_address) }
    it { should have_content(listing.street_address) }
    describe 'features' do
      describe 'when yard if not set' do
        before do
          listing.yard = false
          listing.save
          visit listing_path(listing)
        end
        it { should_not have_text 'yard' }
      end
      describe 'when yard if  set' do
        before do
          listing.yard = true
          listing.save
          visit listing_path(listing)
        end
        it { should have_text 'yard' }
        end
      describe 'when patio if not set' do
        before do
          listing.patio = false
          listing.save
          visit listing_path(listing)
        end
        it { should_not have_text 'patio' }
      end
      describe 'when patio if  set' do
        before do
          listing.patio = true
          listing.save
          visit listing_path(listing)
        end
        it { should have_text 'patio' }
      end
    end

    describe 'xml' do
      before { visit listing_path(listing, format: :xml) }

      it { should have_xpath "//property[@id='#{listing.id}']" }
    end
  end

  describe 'edit' do
    let(:listing) { FactoryGirl.create(:listing, user_id: user.id) }
    before { visit edit_listing_path(listing) }

    it { should have_field 'listing_yard' }
    it { should have_field 'listing_patio' }
  end
end
