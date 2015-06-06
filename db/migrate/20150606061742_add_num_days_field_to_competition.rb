class AddNumDaysFieldToCompetition < ActiveRecord::Migration
  def change
  		add_column :competitions, :num_days, :integer
  end
end
