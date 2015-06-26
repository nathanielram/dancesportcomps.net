# == Schema Information
#
# Table name: competitions
#
#  id               :integer          not null, primary key
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comp_association :string
#  website          :string
#  slug             :string
#

class Competition < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  has_many :occurences, dependent: :destroy
  has_many :locations, through: :occurences

  accepts_nested_attributes_for :occurences
  accepts_nested_attributes_for :locations


  validates :name, :comp_association, :country, presence: true
#  validates :name, :location_name, :address, :city, :country, :comp_association, :website, :num_days, :start_date, :latitude, :longitude, presence: true
#  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
#  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

#  geocoded_by :location_short

#  before_validation :geocode, on: [:create, :update], if: :location_updated?

  # def num_days
  #   if self.end_date.nil? 
  #     1
  #   else
  #     ((self.end_date.to_date - start_date.to_date).to_i + 1) 
  #   end
  #   #else 1 end
  # end

  # def num_days=(num_days)
  #   self.end_date = start_date + (num_days.to_i - 1).days
  # end

#  def location_short
#    [address, city, country].compact.join(", ")
#  end

#  def location
#    [address, city, country_name].compact.join(", ")
#  end    

#  def country_name
#    ISO3166::Country[country.to_s].name unless country.to_s.empty?
#  end

  def local_comp_association
    a = {}

    a[:CA] = {}
    a[:CA][:WDC] = "CDF/NDCC"
    a[:CA][:WDSF] = "Dancesport Canada"

    a[:US] = {}
    a[:US][:WDC] = "NDCA"
    a[:US][:WDSF] = "USA Dance"

    # if !a[country.to_sym].nil? && (a[country.to_sym].key? comp_association.to_sym)
    #   "#{a[country.to_sym][comp_association.to_sym]} (#{comp_association})"
    # else
    #   comp_association
    # end
    if !a[country.to_sym].nil? && (a[country.to_sym].key? comp_association.to_sym)
      "#{a[country.to_sym][comp_association.to_sym]} (#{comp_association})"
    else
      comp_association
    end
  end

  def website_full
    /^http/i.match(website.to_s) ? website.to_s : "http://#{website}"
  end

  def form_select
    "#{name} - #{country_name}"
  end

  private
  # def location_updated?
  #   #(latitude.nil? || longitude.nil?) ||
  #   address_changed? || city_changed? || country_changed?
  #   # location_changed?
  # end

  def slug_candidates
    [
      :name#,
      #[:name, start_date.year]
    ]
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

  def country_name
    ISO3166::Country[country.to_s].name unless country.to_s.empty?
  end

end
