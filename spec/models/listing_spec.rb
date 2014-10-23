require 'spec_helper'

describe Listing do
	let(:user) { FactoryGirl.create(:user) } 
	before do
		@listing = Listing.new(street_address: "Some address")
	end

	subject { @listing }

	it { should respond_to(:agent_id) }   
	it { should respond_to(:main_photo) }
	it { should respond_to(:street_address) }
	it { should respond_to(:zip_code) }
	it { should respond_to(:price) }
	it { should respond_to(:size) }
	it { should respond_to(:description) }  

	it { should be_valid }

	describe 'when address is blank' do
		before { @listing.street_address = '' }
		it { should_not be_valid }
	end
end
