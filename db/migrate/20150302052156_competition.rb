class Competition < ActiveRecord::Migration
  def change
  	add_column :competitions, :slug, :string, unique: true
  end
end
