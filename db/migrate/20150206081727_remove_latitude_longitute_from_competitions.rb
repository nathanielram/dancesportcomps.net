class RemoveLatitudeLongituteFromCompetitions < ActiveRecord::Migration
  def change
  	add_column :competitions, :location, :string
  	add_column :competitions, :association, :string
    remove_column :competitions, :latitude
    remove_column :competitions, :longitude
  end
end
