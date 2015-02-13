class AddTimestampsToHistoryRecords < ActiveRecord::Migration
  def change
    add_timestamps(:history_records)
  end
end
