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
#  location_name    :string
#

class Competition < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  validates :name, :location_name, :address, :city, :country, :comp_association, presence: true
  #validates_format_of :website, :with => URI::regexp(%w(http https))
  validate :end_after_start#, :validate_dates

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

  def local_comp_association
    a = {}

    a[:CA] = {}
    a[:CA][:WDC] = "CDF/NDCC"
    a[:CA][:WDSF] = "Dancesport Canada"

    a[:US] = {}
    a[:US][:WDC] = "NDCA"
    a[:US][:WDSF] = "USA Dance"

    if a[country.to_sym].key? comp_association.to_sym
      "#{a[country.to_sym][comp_association.to_sym]} (#{comp_association})"
    else
      comp_association
    end
  end

  def website_full
    /^http/i.match(website.to_s) ? website.to_s : "http://#{website}"
  end

  private
  def location_updated?
    address_changed? || city_changed? || country_changed?
    # location_changed?
  end

  def end_after_start
    errors.add(:end_date, "must be after the start date") if Date.parse("#{end_date}") < Date.parse("#{start_date}")
  end

  def validate_dates
    errors.add(:start_date, "is not a valid date") if Date.parse("#{start_date}").to_s != "#{start_date}"
    errors.add(:end_date, "is not a valid date") if Date.parse("#{end_date}").to_s != "#{end_date}"
  end

  def slug_candidates
    [
      #:name,
      [:name, start_date.year]
    ]
  end
end
