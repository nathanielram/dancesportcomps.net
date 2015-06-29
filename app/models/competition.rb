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
#  country          :string
#

class Competition < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  has_many :occurences, -> { order(start_date: :desc) }, dependent: :destroy
  has_many :locations, through: :occurences

  #accepts_nested_attributes_for :occurences
  #accepts_nested_attributes_for :locations

  validates :name, :comp_association, :country, presence: true
  validates :name, uniqueness: true

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
    ISO3166::Country[country.to_s].name unless (country.to_s.empty? && ISO3166::Country[country.to_s].nil?)
  end

end
