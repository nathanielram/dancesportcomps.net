class RemoveFieldsFromCompetition < ActiveRecord::Migration
  def change
  	remove_column :competitions, :start_date, :date
  	remove_column :competitions, :end_date, :date
  	remove_column :competitions, :address, :string
  	remove_column :competitions, :city, :string
  	#remove_column :competitions, :country, :string
  	remove_column :competitions, :latitude, :float
  	remove_column :competitions, :longitude, :float
  	remove_column :competitions, :location_name, :string
  end
end
