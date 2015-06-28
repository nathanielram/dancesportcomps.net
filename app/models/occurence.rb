# == Schema Information
#
# Table name: occurences
#
#  id             :integer          not null, primary key
#  start_date     :date
#  end_date       :date
#  competition_id :integer
#  location_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Occurence < ActiveRecord::Base

	belongs_to :competition
	belongs_to :location
	
	#accepts_nested_attributes_for :competition
	#accepts_nested_attributes_for :location


	validates :num_days, :start_date, :competition, :location, presence: true

	validate :competition_and_location_in_same_country

	def num_days
    if self.end_date.nil? 
      1
    else
      ((self.end_date.to_date - start_date.to_date).to_i + 1) 
    end
    #else 1 end
  end

  def num_days=(num_days)
    self.end_date = start_date + (num_days.to_i - 1).days
  end

  private
  def competition_and_location_in_same_country
  	if competition.country != location.country
  		errors.add(:competition, "must be in the same country as Location")
  		errors.add(:location, "must be in the same country as Competition")
  		#competition.errors.add(:country, "must be in the same country as location")
  		#location.errors.add(:country, "must be in the same country as competition")
  	end
  end

end
