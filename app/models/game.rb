class Game < ApplicationRecord
  reverse_geocoded_by :latitude, :longitude
  before_validation :reverse_geocode if Proc.new { longitude_changed? || latitude_changed? }
end
