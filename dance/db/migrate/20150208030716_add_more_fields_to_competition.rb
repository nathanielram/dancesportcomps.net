class AddMoreFieldsToCompetition < ActiveRecord::Migration
  def change
  	add_column :competitions, :address, :string
    add_column :competitions, :city, :string
    add_column :competitions, :country, :string
    add_column :competitions, :website, :string
  end
end
