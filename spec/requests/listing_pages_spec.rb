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
        it { should_not have_text 'Yard' }
      end
      describe 'when yard if  set' do
        before do
          listing.yard = true
          listing.save
          visit listing_path(listing)
        end
        it { should have_text 'Yard' }
      end

      describe 'when patio if not set' do
        before do
          listing.patio = false
          listing.save
          visit listing_path(listing)
        end
        it { should_not have_text 'Patio' }
      end
      describe 'when patio is  set' do
        before do
          listing.patio = true
          listing.save
          visit listing_path(listing)
        end
        it { should have_text 'Patio' }
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

  describe 'index' do
    describe 'xml' do
      let(:sale_listing) { FactoryGirl.create(:listing, listing_type_id: ListingType.where(name: 'Sale').first.id) }
      let(:rental_listing) { FactoryGirl.create(:listing, listing_type_id: ListingType.where(name: 'Rental').first.id) }
      describe 'invalid params' do
        describe 'when zero params' do
          before { visit listings_path(format: :xml) }
          it { should have_xpath '//properties' }
          it { should_not have_xpath '//property' }
        end

        describe 'when no the to param' do
          before { visit listings_path(format: :xml, type: 'all') }
          it { should have_xpath '//properties' }
          it { should_not have_xpath '//property' }
        end

        describe 'when no the type param' do
          before { visit listings_path(format: :xml, to: 'streeteasy') }
          it { should have_xpath '//properties' }
          it { should_not have_xpath '//property' }
        end
      end

      describe 'streeteasy' do
        describe 'no export flag' do
          before { visit listings_path(format: :xml, to: 'streeteasy', type: 'all') }
          it { should have_xpath '//properties' }
          it { should_not have_xpath '//property' }
        end

        describe 'with export flag' do
          before do
            sale_listing.export_to_streeteasy = true
            sale_listing.save!
            visit listings_path(format: :xml, to: 'streeteasy', type: 'all')
          end
          it { should have_xpath '//properties' }
          it { should have_xpath "//property[@id='#{sale_listing.id}']" }
          it { should_not have_xpath "//property[@id='#{rental_listing.id}']" }
        end
      end
    end
  end
end
