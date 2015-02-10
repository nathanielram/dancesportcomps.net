# == Schema Information
#
# Table name: competitions
#
#  id               :integer          not null, primary key
#  name             :string
#  start_date       :date
#  end_date         :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  location         :string
#  comp_association :string
#  address          :string
#  city             :string
#  country          :string
#  website          :string
#  latitude         :float
#  longitude        :float
#

class Competition < ActiveRecord::Base
  validates :name, :address, :city, :country, :comp_association, presence: true

  #validates_date :start_date
  #validates_date :end_date, on_or_after: :start_date

  geocoded_by :location_short

  after_validation :geocode, on: [:create, :update], if: :location_updated?

  def location_short
    [address, city, country].compact.join(", ")
  end

  def location
    [address, city, country_name].compact.join(", ")
  end    

  def country_name
    ISO3166::Country[country.to_s].name unless country.to_s.empty?
  end

  private
  def location_updated?
    address_changed? || city_changed? || country_changed?
    # location_changed?
  end

end
