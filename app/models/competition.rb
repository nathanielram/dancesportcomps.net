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
  validates :name, :location_name, :address, :city, :country, :comp_association, presence: true
  #validate :end_after_start, :validate_dates

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

  def end_after_start
    # return if start_date.blank? || end_date.blank?
    errors.add(:end_date, "must be after the start date") if :end_date < :start_date
  end

  def validate_dates
    errors.add(:start_date, "is not a valid date") unless Date.valid_date?("start_date(1i)".to_i, "start_date(2i)".to_i, "start_date(3i)".to_i)
    #errors.add(:end_date, "is not a valid date") if Date.valid_date?(:end_date)
  end

end
