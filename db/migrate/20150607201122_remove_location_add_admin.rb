class RemoveLocationAddAdmin < ActiveRecord::Migration
  def change
  	remove_column :competitions, :location
  end
end
