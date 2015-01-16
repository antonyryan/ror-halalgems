class NeighborhoodsController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user

  def index
    respond_to do |format|
      format.html do
        @neighborhood = Neighborhood.new
        @neighborhoods = Neighborhood.all
      end
			format.json do 				
				render :json => Neighborhood.where("lower(name) like lower(?)", "%#{params[:term]}%").map{|neighborhood| {id: neighborhood.id, name: neighborhood.name, value: neighborhood.name}}
			end			
		end
  end

  def create
    @neighborhood = Neighborhood.new(neighborhood_params)
    respond_to do |format|
      if @neighborhood.save
        format.html do
          flash[:success] = "Points was added!"
          redirect_to neighborhoods_path
        end
        format.js
      else
        format.html do
          @neighborhood = Neighborhood.new
          render 'index'
        end
        format.js
      end
    end
  end


  def edit
    @neighborhood = Neighborhood.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @neighborhood = Neighborhood.find(params[:id])
    respond_to do |format|
      if params[:commit] == 'Save'
        if @neighborhood.update_attributes(neighborhood_params)
          format.html do
            flash[:success] = "Data updated"
            redirect_to neighborhoods_path
          end
          format.js
        else
          format.html do
            render 'edit'
          end
          format.js
        end
      else
        format.html { redirect_to neighborhoods_path }
        format.js
      end
    end
  end

  def destroy
    neighborhood = Neighborhood.find(params[:id])
    neighborhood.destroy
    redirect_to :back
  end

  private

  def neighborhood_params
    params.require(:neighborhood).permit(:name)
  end
end
