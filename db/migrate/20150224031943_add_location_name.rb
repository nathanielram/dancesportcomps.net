class AddLocationName < ActiveRecord::Migration
  def change
 	add_column :competitions, :location_name, :string
  end
end
