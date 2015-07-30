class ReportsController < ApplicationController
  def listings_by_period
    @start_date = params[:start_date] || 1.month.ago.beginning_of_day
    @end_date = params[:end_date] || Date.current.end_of_day

    @total = Listing.where(created_at: @start_date..@end_date).count

    @agent_count = Listing.where(created_at: @start_date..@end_date).group(:user_id).count
    # @plot_data = @agent_count.map {|record| [record[0], record[1]]}
    @plot_data = @agent_count.map.with_index {
        |record, index|  {label: User.find(record[0]).name, data:[[index, record[1]]] }
    }.to_json

  end
end
