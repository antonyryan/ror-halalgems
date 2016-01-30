class UsersController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.active_users.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])

    if sort_column.include? '.'
      parts = sort_column.split('.')
      @listingss = @user.listings.includes(parts.first).order("#{parts.first.pluralize}.#{parts.last}" + ' ' + sort_direction)
    else
      @listingss = @user.listings.order(sort_column + ' ' + sort_direction)
    end

    #todo: sorting breaks hidden_listings param
    #todo: code dupl with listings_controller.rb
    if params[:status].present?
      if params[:status] == 'Active'
        @listingss = @listingss.available_listings
      elsif params[:status] == 'Unavailable'
        @listingss = @listingss.hidden_listings
      elsif params[:status] == 'Pending'
        @listingss = @listingss.pending_listings
      end
    else
      @listingss = @listingss.available_listings
    end

    sale_obj = ListingType.find_by_name('Sale')

    @sale_id = ListingType.find_by(name: 'Sale').id
    @rental_id = ListingType.find_by(name: 'Rental').id
    @commercial_id = ListingType.find_by(name: 'Commercial').id

    if params[:display].present?
      @display = params[:display]
    else
      @display = 'thumb_list'
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #sign_in @user
      flash[:success] = 'User created.'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.active = false
    user.save
    flash[:success] = 'User destroyed.'
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :avatar, :phone, :fax, :biography,
                                 :address, :license_type, :license_no, :social_security_no, :commision_split, :naked_apartments_account)
  end

  # Before filters

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) || current_user.admin?
  end


end
