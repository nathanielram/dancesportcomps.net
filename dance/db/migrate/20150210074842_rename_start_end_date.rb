class RenameStartEndDate < ActiveRecord::Migration
  def change
  	rename_column :competitions, :start, :start_date
  	rename_column :competitions, :end, :end_date
  end
end
