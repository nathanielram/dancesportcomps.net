class RenameAssocationInCompetition < ActiveRecord::Migration
  def change
  	rename_column :competitions, :association, :comp_association
  end
end
