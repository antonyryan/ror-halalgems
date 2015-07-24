require 'spec_helper'

describe 'ReportsPages' do
  let(:user) { FactoryGirl.create :admin }
  before { sign_in user }
  subject { page }

  describe 'listings by period' do
    let!(:old_listing) { FactoryGirl.create :listing, created_at: 2.month.ago }
    before do
      2.times { FactoryGirl.create :listing, user_id: user.id }
      FactoryGirl.create :listing
      visit listings_by_period_reports_path
    end

    it { should have_title(full_title('Report: Listings by period')) }
    it { should have_selector '#total', text: '3' }
  end
end
