class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  helper_method :display_helper, :sort_column, :sort_direction

  def display_helper
    params[:display] || 'list'
  end

  def sort_column
    #Listing.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
    params[:sort] || 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
