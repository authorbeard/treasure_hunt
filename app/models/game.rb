class Game < ApplicationRecord
  validates :latitude, :longitude, presence: true

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode if Proc.new { longitude_changed? || latitude_changed? }

  def self.generate_new 
  end
end
