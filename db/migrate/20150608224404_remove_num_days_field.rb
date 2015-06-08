class RemoveNumDaysField < ActiveRecord::Migration
  def change
  	 remove_column :competitions, :num_days
  end
end
