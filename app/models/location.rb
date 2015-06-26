# == Schema Information
#
# Table name: locations
#
#  id           :integer          not null, primary key
#  name         :string
#  address      :string
#  city         :string
#  country      :string
#  latitude     :float
#  longitude    :float
#  occurence_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Location < ActiveRecord::Base

	# belongs_to :occurence
	has_many :competitions, through: :occurences
  has_many :occurences

  #accepts_nested_attributes_for :competitions
  #accepts_nested_attributes_for :occurences

  validates :name, :address, :city, :country, :latitude, :longitude, presence: true
  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  geocoded_by :location_short

  before_validation :geocode, on: [:create, :update], if: :location_updated?

	def location_short
    [address, city, country].compact.join(", ")
  end

  def location
    [address, city, country_name].compact.join(", ")
  end 

  def city_full
  	[city, country_name].compact.join(", ")
  end   

  def form_select 
  	"#{name} - #{city_full}"
  end

  private
  def location_updated?
    #latitude.nil? || longitude.nil? ||
    address_changed? || city_changed? || country_changed?
    # location_changed?
  end

  def country_name
    ISO3166::Country[country.to_s].name unless country.to_s.empty?
  end
end
