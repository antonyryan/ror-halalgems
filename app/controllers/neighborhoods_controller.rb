class NeighborhoodsController < ApplicationController
  def index
  	respond_to do |format|			
			format.json do 				
				render :json => Neighborhood.where("name like ?", "%#{params[:q]}%").map{|neighborhood| {id: neighborhood.id, name: neighborhood.name}}
			end			
		end
  	end
end
