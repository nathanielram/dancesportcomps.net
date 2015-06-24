class CreateOccurences < ActiveRecord::Migration
  def change
    create_table :occurences do |t|
      t.date :start_date
      t.date :end_date
      t.belongs_to :competition, index: true
      t.belongs_to :location, index: true

      t.timestamps null: false
    end
  end
end
