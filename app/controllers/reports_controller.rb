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

  def rented_listings_by_period
    @start_date = params[:start_date] || 1.month.ago.beginning_of_day
    @end_date = params[:end_date] || Date.current.end_of_day

    @agent_count = Listing.joins(:history_records)
                       .where("history_records.created_at >= ? AND history_records.created_at <= ? and history_records.message like '%to ''Rented''%'",
        @start_date.to_datetime.beginning_of_day, @end_date.to_datetime.end_of_day).group(:user_id).count

    @plot_data = @agent_count.map.with_index {
        |record, index|  {label: User.find(record[0]).name, data:[[index, record[1]]] }
    }.to_json

    @total = @agent_count.inject(0) {|sum, arr| sum + arr[1]}

    render :listings_by_period

  end
end
