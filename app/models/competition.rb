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
#  slug             :string
#  num_days         :integer
#

class Competition < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  validates :name, :location_name, :address, :city, :country, :comp_association, :website, :num_days, :start_date, presence: true

  geocoded_by :location_short

  after_validation :geocode, on: [:create, :update], if: :location_updated?

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

    if !a[country.to_sym].nil? && (a[country.to_sym].key? comp_association.to_sym)
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

  def slug_candidates
    [
      #:name,
      [:name, start_date.year]
    ]
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

end
