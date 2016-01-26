require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "index" do
		let(:user) { FactoryGirl.create(:user) }
		before(:each) do
			sign_in user
			visit users_path
		end

		it { should have_title('Agents') }
		it { should have_content('Agents') }

		describe "pagination" do

			before(:all) { 31.times { FactoryGirl.create(:user) } }
			after(:all)  { User.delete_all }

			it { should have_selector('div.pagination') }

			it "should list each user" do
				User.paginate(page: 1).each do |user|
					expect(page).to have_selector('a', text: user.name)
				end
			end
		end		
	end

	describe 'profile page' do
		let(:user) { FactoryGirl.create(:user) }
		let!(:l1) { FactoryGirl.create(:listing, user: user, street_address: 'Foo') }
    let!(:l2) { FactoryGirl.create(:listing, user: user, street_address: 'Bar') }

		before do
      ListingType.create([{name: 'Sale'}, {name: 'Rental'}, {name: 'Commercial'}])
			sign_in user		
			visit user_path(user) 
		end

		it { should have_content(user.name) }
		it { should have_title(user.name) }

    it { should have_link 'Create rental'}
    it { should have_link 'Create sale'}
    it { should have_link 'Create commercial'}

		describe "microposts" do
	      it { should have_content(l1.street_address) }
	      it { should have_content(l2.street_address) }
	      #it { should have_content(user.listings.count) }
	    end	 

	    describe "delete links" do

			it { should_not have_link('delete') }

			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit user_path(user)
				end

				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect do
						click_link('delete', match: :first)
					end.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: user_path(admin)) }
			end
		end   
	end

	describe "new user page" do
		let(:admin) { FactoryGirl.create(:admin) }
		before do 
			sign_in admin
			visit new_user_path 
		end

		it { should have_content('New user') }
		it { should have_title(full_title('New user')) }
	end

	describe "creating user" do
		let(:admin) { FactoryGirl.create(:admin) }
		before do 
			sign_in admin
			visit new_user_path 
		end
		let(:submit) { "Create account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name",         with: "Example User"
				fill_in "Email",        with: "user@example.com"
				fill_in "Password",     with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by(email: 'user@example.com') }

				it { should have_link('Sign out') }
				it { should have_title(user.name) }
				it { should have_selector('div.alert.alert-success', text: 'User created.') }
			end
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_content("Edit agent info") }
			it { should have_title("Edit agent info") }	

			it { should_not have_selector("input[name='user[password]']") }
			it { should have_link("change password") }

			describe "admin info" do		    	
  				it {should_not have_selector("input[name='user[license_no]'][value='123456']")}

		    	describe "as admin user" do
		    		let(:admin) { FactoryGirl.create(:admin) }
					before do
						sign_in admin
						visit edit_user_path(user)
						click_link 'Special'
					end

					it {should have_selector("input[name='user[license_no]'][value='123456']")}
		    	end
		    end		
		end

		describe "with invalid information" do
			before { click_button "Save changes" }

			it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_name)  { "New Name" }
			let(:new_email) { "new@example.com" }
			before do
				fill_in "Name",             with: new_name
				fill_in "Email",            with: new_email
				fill_in "Password",         with: user.password
				fill_in "Confirm Password", with: user.password
				click_button "Save changes"
			end

			it { should have_title(new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { expect(user.reload.name).to  eq new_name }
			specify { expect(user.reload.email).to eq new_email }
		end

		describe "password changin" do
			describe "should show the form" do
				before { click_link "change password" }
				it { should have_selector("password_from") }
			end

		end

		describe "forbidden attributes" do
			let(:params) do
				{ user: { admin: true, password: user.password,
					password_confirmation: user.password } }
				end
				before do
					sign_in user, no_capybara: true
					patch user_path(user), params
				end
				specify { expect(user.reload).not_to be_admin }
			end
		end 
	end