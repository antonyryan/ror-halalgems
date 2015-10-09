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

    describe 'change agent' do
      let(:admin_user) { FactoryGirl.create(:admin) }
      describe 'as regular user' do
        it { should_not have_field 'listing_user_id' }
      end

      describe 'as admin user' do
        before do
          sign_in admin_user
          visit edit_listing_path(listing)
        end
        describe 'page' do
          it { should have_field 'listing_user_id' }
        end
        describe 'save' do
          before do
            page.select admin_user.name, from: 'listing_user_id'
            click_button 'Save'
          end
          specify { expect(listing.reload.user_id).to  eq admin_user.id }
        end
      end

    end
  end

  describe 'index' do
    describe 'xml' do
      let (:neighborhood) { FactoryGirl.create(:neighborhood) }
      let (:fake_neighborhood) { FactoryGirl.create(:neighborhood) }
      let(:sale_listing) { FactoryGirl.create(:listing, listing_type_id: ListingType.where(name: 'Sale').first.id,
                                              street_address: 'test', unit_no: '1B', neighborhood_id: neighborhood.id) }
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

          describe 'address' do
            describe 'when address 2 is empty' do
              it { should have_selector 'address', text: 'test' }
            end

            describe 'when address 2 is present' do
              before do
                sale_listing.fake_address = 'fake'
                sale_listing.save!
                visit listings_path(format: :xml, to: 'streeteasy', type: 'all')
              end
              it { should_not have_selector 'address', text: 'test' }
              it { should have_selector 'address', text: 'fake' }
            end
          end

          describe 'unit_no' do
            describe 'when fake_unit_no is empty' do
              it { should have_selector 'apartment', text: '1B' }
            end

            describe 'when fake_unit_no is present' do
              before do
                sale_listing.fake_unit_no = 'fake_unit_no'
                sale_listing.save!
                visit listings_path(format: :xml, to: 'streeteasy', type: 'all')
              end
              it { should_not have_selector 'apartment', text: '1B' }
              it { should have_selector 'apartment', text: 'fake_unit_no' }
            end
          end

          describe 'city' do
            describe 'when fake_city_id is empty' do
              it { should have_selector 'city', text: neighborhood.name }
            end

            describe 'when fake_city_id is present' do
              before do
                sale_listing.fake_city_id = fake_neighborhood.id
                sale_listing.save!
                visit listings_path(format: :xml, to: 'streeteasy', type: 'all')
              end
              it { should_not have_selector 'city', text: neighborhood.name }
              it { should have_selector 'city', text: fake_neighborhood.name }
            end
          end
        end
      end
    end
  end
end
