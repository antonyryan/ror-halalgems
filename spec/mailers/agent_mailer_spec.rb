require 'spec_helper'

describe AgentMailer do
  let!(:active_user) { FactoryGirl.create(:user) }
  let!(:inactive_user) { FactoryGirl.create :user, active: false }
  # let(:neighborhood) { FactoryGirl.create(:neighborhood) }
  let(:listing) { FactoryGirl.create :listing, user: active_user }

  describe 'create_listing' do
    let(:email) { AgentMailer.listing_created(listing) }

    it 'renders the subject' do
      expect(email.subject).to eq('Listing has been created')
    end

    describe 'receivers' do
      it 'renders the receiver email' do
        expect(email.to).to eql([active_user.email])
      end
      it "not renders inactive user's email in the receiver email" do
        expect(email.to).not_to include(inactive_user.email)
      end
    end

    it 'assigns listing url' do
      expect(email.body.encoded).to include("http://mighty-castle-9932.herokuapp.com/listings/#{listing.id}")
    end
  end

  describe 'listing status changed' do
    let(:email) { AgentMailer.listing_changed(listing, 'some old status', 'some new status') }

    it 'renders the subject' do
      expect(email.subject).to eq('Listing status has been changed')
    end

    describe 'receivers' do
      it 'renders the receiver email' do
        expect(email.to).to eql([active_user.email])
      end
      it "not renders inactive user's email in the receiver email" do
        expect(email.to).not_to include(inactive_user.email)
      end
    end

    it 'assigns listing url' do
      expect(email).to have_link("http://mighty-castle-9932.herokuapp.com/listings/#{listing.id}")
    end

    it 'renders old status' do
      expect(email).to have_content('some old status')
    end

    it 'renders new status' do
      expect(email).to have_content('some new status')
    end

  end
end
