class ReportsController < ApplicationController
  def listings_by_period
    @start_date = params[:start_date] || 1.month.ago.beginning_of_day
    @end_date = params[:end_date] || Date.current.end_of_day

    @total = Listing.where(created_at: @start_date..@end_date).count

    @agent_count = Listing.where(created_at: @start_date..@end_date).group(:user_id).count
  end
end
